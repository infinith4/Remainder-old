package Remainder::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

Remainder::Controller::Root - Root Controller for Remainder

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

#sub index :Path :Args(0) {
sub index :Local {
    my ( $self, $c ) = @_;

    # Hello World
    #$c->response->body( $c->welcome_message );
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

sub remainder :Local {
	my ($self ,$c) = @_;
	$c->stash->{list} = [$c->model('CatalDB::Book')->all];
    $c->stash->{title} = 'Remainder - あなたの気になるをお知らせ！ -';
   
}

sub memo :Local {
	my ($self ,$c) = @_;
	#$c->stash->{list} = [$c->model('CatalDB::Book')->all];
    my $memo = $c->request->body_params->{'textarea'};
    #print $memo;
    my $weektimes = $c->request->body_params->{'weektimes'};
    #print $weektimes;
    my $days = $c->request->body_params->{'days'};
    #$c->stash->{day} = join ',',@$day;
    my $notification = $c->request->body_params->{'notification'};
	#$c->stash->{list} = [$c->model('CatalremaindDB::RemainderMemo')->all];
    #レコードへ登録
#=pod
    my $row = $c->model('RemainderDB::RemainderMemo')->create({
        memo => 'test02',
        weektimes => $weektimes,
        days => $days,
        notification => $notification,
        created => '\NOW()',
        updated => '\NOW()',
    });
    #$c->response->body('success')
#=cut
    #print $day;
    #$c->stash->{day} = join ',',@$day;
}
sub memolist :Local {
	my ($self ,$c) = @_;
	$c->stash->{list} = [$c->model('RemainderDB::RemainderMemo')->all];
}

=head1 AUTHOR

th4,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
