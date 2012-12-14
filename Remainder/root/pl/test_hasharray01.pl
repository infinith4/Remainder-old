#!/usr/bin/perl

use strict;
use warnings;

my @hoge=("aaa","bbb");

my %hash=("hog" => @hoge);

sub hoge1{
    #my($h)=@_;
    
#    print $$h{hog}[0],"\n";
#うまく行かない
    foreach my $el (@{$_[0]{hog}}){
        print "$el\n";
    }
}

&hoge1(\%hash);


