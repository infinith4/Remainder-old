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

sub dispatcher{
    print "ID: ", shift, "\n";
    print "Args:","@_", "\n";
}
    #必要なデータはmysqlから呼び出す.
    my $userid ="tashirohiro4";#given
    my $usermail = "infinith4\@gmail.com";#given
    my $subject = "[test] Remainder";

    my $frommail = "remainder.information\@gmail.com";
    my $frommailpassword = "ol12dcdbl0jse1l";

    my $mailcontent = "- Remainder -あなたの気になるをお知らせ-\n $frommail";

sub job{
# 実行したい処理（メール送信、時間設定ファイルの読み込み？）
#    my @arr = @_;
    my $i=0;
#    for (my $i = 0;$i < scalar(@arr) ;$i++){
        print "job:\n";
#    }
}


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
#print $dt;
$dt =~ s/T/ /g;
#print $dt;
#print $dt;
# SQL文を用意
#                              0   1      2    3    4        5     6
#my $sth = $db->prepare("SELECT id,userid,memo,tag,fromtime,totime,days FROM RemainderMemo WHERE '$dt' >= fromtime and days like '%$dayabbr%' ORDER BY fromtime asc"); #fromtime でソート.現在以前
my $sth = $db->prepare("SELECT id,userid,memo,tag,fromtime,totime,days FROM RemainderMemo WHERE '$dt' >= fromtime ORDER BY fromtime asc"); #fromtime でソート.現在以前
#取得されるべき値
#my $min = 12;#given
#my $hour = 17;#given
#my $days = "Sun,Mon,Wed,Sat";#given

if(!$sth->execute){
    print "SQL失敗\n";
    exit;
}

my @memos;

while (my @rec = $sth->fetchrow_array) {
    push(@memos,$rec[2]);

}

my $cron = new Schedule::Cron(\&dispatcher);

$cron->add_entry("57 21 * * * ", \&job);

#$cron->add_entry("0 8 * * * ", \&job(@memos));
#$cron->add_entry("0 12 * * * ", \&job(@memos));
#$cron->add_entry("0 15 * * * ", \&job(@memos));
#$cron->add_entry("0 21 * * * ", \&job(@memos));



$cron->run();

