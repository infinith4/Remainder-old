#!/usr/bin/perl

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use OAuth::Lite::Consumer;
use OAuth::Lite::Token;

my $consumer_key   = 'PgpEemhYpWeviQ==';
my $consumer_secret    = 'YXPnSMwBfljWzXVtl9hcmTu1J3g=';

my $title = 'Test Hatena OAuth API';

sub save_request_token {
    my ($request_token) = @_;

    open(TOKEN, ">.session")    or die $!;
    print TOKEN $request_token->as_encoded;
    close(TOKEN);
}

sub load_request_token {
    open(TOKEN, ".session")     or die $!;
    my $request_token = OAuth::Lite::Token->from_encoded(<TOKEN>);
    close(TOKEN);

    return $request_token;
}

my $cgi = new CGI;

my $consumer = new OAuth::Lite::Consumer(
        consumer_key    => $consumer_key,
        consumer_secret => $consumer_secret,
    );

if (! $cgi->param()) {
    my $request_token = $consumer->get_request_token(
            url             => 'https://www.hatena.com/oauth/initiate',
            callback_url    => $cgi->url,
            scope           => 'write_public,read_private',
        )   or die $consumer->errstr."\n";
    save_request_token($request_token);
    print $cgi->redirect(
            $consumer->url_to_authorize(
                url     => 'https://www.hatena.ne.jp/oauth/authorize',
                token   => $request_token,
        ));
}
else {
    my $oauth_verifier  = $cgi->param('oauth_verifier');
    my $request_token   = load_request_token();

    my $access_token = $consumer->get_access_token(
            url         => 'https://www.hatena.com/oauth/token',
            token       => $request_token,
            verifier    => $oauth_verifier,
        );

    print $cgi->header,
          $cgi->start_html(-title=>$title)
              . $cgi->h1($cgi->a({href=>$cgi->url},$title))
        . $cgi->dl(
                $cgi->dt('Access Token:'), $cgi->dd($access_token->token),
                $cgi->dt('Access Secret:'), $cgi->dd($access_token->secret),
            )
        . $cgi->end_html;
}
