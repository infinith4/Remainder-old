#!/usr/bin/perl

use strict;
use warnings;
use DateTime;


my $dt = DateTime->now( time_zone => 'Asia/Tokyo' );
my $hour = $dt->hour() ,"\n";
my $min = $dt->minute() ,"\n";


print $hour;
