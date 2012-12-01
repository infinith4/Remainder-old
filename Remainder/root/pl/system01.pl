#!/usr/bin/perl

use strict;
use warnings;

my $return_value = system "grep 'hoge' secret_data.txt";
