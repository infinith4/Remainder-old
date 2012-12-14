#!/usr/bin/perl

use strict;
use warnings;

use WWW::Mechanize;

# login
my $login_url = 'https://www.google.com/accounts/Login?hl=ja&continue=http://www.google.co.jp/';

my $mech = WWW::Mechanize->new();
$mech->get( $login_url );
$mech->submit_form(
    form_number => 1,
    fields => do '.config.pl',
    );

# access google contents
$mech->get('https://www.google.com/');
print $mech->content();
