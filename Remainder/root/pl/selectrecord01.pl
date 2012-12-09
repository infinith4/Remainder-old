#!/usr/bin/perl

use strict;
use warnings;

use Schedule::Cron;

use DBI;
use Email::Sender::Simple qw(sendmail);
use Email::Simple;
use Email::Simple::Creator;
use Email::Sender::Transport::SMTP;
use DateTime;

#script/reamainder_server.pl とは別に、メール送信用にscriptを走らせておく。

# データソース
my $d = 'DBI:mysql:remainderdb';
# ユーザ名
my $u = 'remainderuser';
# パスワード
my $p = 'remainderpass';

# データベースへ接続
my $db = DBI->connect($d, $u, $p);

if(!$db){
    print "接続失敗\n";
    exit;
}

my $dt = DateTime->now( time_zone => 'Asia/Tokyo' );
my  $dayabbr    = $dt->day_abbr;   # 曜日の省略名
$dt =~ s/T/ /g;

#print $dt;
# SQL文を用意
#                              0   1      2    3    4        5     6
my $sth = $db->prepare("SELECT id,userid,memo,tag,fromtime,totime,days FROM RemainderMemo WHERE '$dt' >= fromtime and days like '%$dayabbr%' ORDER BY fromtime asc"); #fromtime でソート.現在以前
#取得されるべき値
#my $min = 12;#given
#my $hour = 17;#given
#my $days = "Sun,Mon,Wed,Sat";#given

if(!$sth->execute){
    print "SQL失敗\n";
    exit;
}

while (my @rec = $sth->fetchrow_array) {
    my $fromtime = $rec[4];
    my $totime = $rec[5];
    my $days = $rec[6];
    print $fromtime,"\n";

}


