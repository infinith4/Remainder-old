#!/usr/bin/perl

use strict;
use warnings;

my $time = "2012-12-02 11:49:00";

$time =~ m/\s/;
my $hourminsec = $';

print "pre:",$`,"\n";
print "post:",$',"\n";

print $hourminsec,"\n";

my @arr =split(/:/,$hourminsec);

push(@hours,$arr[0]);
push(@mins,$arr[1]);


