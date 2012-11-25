package Remainder::View::TT;
use strict;
use warnings;

#use namespace::autoclean;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    #render_die => 1,
);

=head1 NAME

Remainder::View::TT - TT View for Remainder

=head1 DESCRIPTION

TT View for Remainder.

=head1 SEE ALSO

L<Remainder>

=head1 AUTHOR

th4,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
