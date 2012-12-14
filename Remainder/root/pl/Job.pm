#!/usr/bin/perl -w
use strict;
use warnings;
use DateTime;

package Schedule::Job;

sub hourmin_entry{

    print "select time is $_[0]:$_[1]:$_[2]\n";
    while(1){
        my $dt = DateTime->now( time_zone => 'Asia/Tokyo' );
        print $dt,"\n";
        
        if(($_[0] == $dt->hour()) && ($_[1] == $dt->minute()) &&  ($_[2] == $dt->second())){
            #$func;
            #last;
            print $_[3],"\n";
        }
        sleep(1);
    }
    
}

sub job{
    
        print "$_[0]\n";
    
}

=pod
sub time {
    while(1){
        my $dt = DateTime->now( time_zone => 'Asia/Tokyo' );
        my $dayabbr    = $dt->day_abbr;   # 曜日の省略名
    }
    return $dt;
}

=cut


=pod
sub subject{
    my $func = $_[0];
    $func;
    print "completed\n";
}
=cut

=pod
my @aaa=("aaa","bbb");
foreach (@aaa){
    &subject(\&callback($_));
}

=cut


my @aaa=("aaa","bbb");

my $bbb="bbb";

#if文が適用されていない
&hourmin_entry(0,46,40,$bbb);

#1;
