#!/usr/bin/perl -w
use strict;
use warnings;
use DateTime;

#package Schedule::Job;

sub hourmin_entry{
    
    while(1){
        my $dt = DateTime->now( time_zone => 'Asia/Tokyo' );
        
        if($_[0] == $dt->hour() && $_[1] == $dt->minute() ){
            $job;
            break;
        }
    }
    
}

sub time {
    while(1){
        my $dt = DateTime->now( time_zone => 'Asia/Tokyo' );
        my $dayabbr    = $dt->day_abbr;   # 曜日の省略名
    }
    return $dt;
}

sub job{
    my $val = $_[0];
    print "$val%\n";
}

sub subject{
    my $func = $_[0];
    $func;
    print "completed\n";
}

=pod
my @aaa=("aaa","bbb");
foreach (@aaa){
    &subject(\&callback($_));
}

=cut

&hourmin_entry(22,22,&job());

#1;
