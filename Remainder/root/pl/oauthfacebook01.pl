use strict;
use warnings;

use Plack::Request;
use Plack::Response;
use LWP::UserAgent;
use URI;
use JSON;
use Encode;

my $app_id = 'YOUR_APP_ID';
my $app_secret = 'YOUR_APP_SECRET';

my $authz_endpoint = 'https://www.facebook.com/dialog/oauth';
my $token_endpoint = 'https://graph.facebook.com/oauth/access_token';

my $app = sub {
    my $env = shift;

    my $req = Plack::Request->new($env);
    my $res = Plack::Response->new;
    my $redirect_uri = $req->base;

    # 2) get authorization code

    if ( my $code = $req->query_parameters->{'code'} ) {

        # 3) get access token

        my $uri = URI->new($token_endpoint);
        $uri->query_form(
            client_id     => $app_id,
            client_secret => $app_secret,
            redirect_uri  => $redirect_uri,
            code          => $code
	    );
        my $ua     = LWP::UserAgent->new;
        my $r      = $ua->get($uri);
        my %params = ();
        for my $pair ( split( /&/, $r->content ) ) {
            my ( $key, $value ) = split( /=/, $pair );
            $params{$key} = $value;
        }
        my $token = $params{access_token};

        # 4) get protected resources

        if ($token) {
            my $url = 'https://graph.facebook.com/me/friends';
            my $uri = URI->new($url);
            $uri->query_form( access_token => $token );

            my $ua = LWP::UserAgent->new;
            my $r  = $ua->get($uri);

            my $json = decode_json( $r->content );
            my $html = '<html><body><ul>';
            for my $f ( @{ $json->{data} } ) {
                $html .= '<li>' . encode( 'utf8' => $f->{name} ) . '</li>';
            }
            $html .= '</ul></body></html>';

            $res->status(200);
            $res->body($html);
        }
        else {
            $res->status(401);
            $res->body('fail to get token');
        }
    }
    
    # 1) redirect to authorization endpoint

    else {
        my $uri = URI->new($authz_endpoint); 
        $uri->query_form(
            client_id    => $app_id,
            redirect_uri => $redirect_uri,
	    );
        $res->redirect($uri);
    }
    return $res->finalize;
};
