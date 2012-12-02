#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use Encode;

# データソース
my $d = 'DBI:mysql:remainderdb';
# ユーザ名
my $u = 'remainderuser';
# パスワード
my $p = 'remainderpass';

# データベースへ接続
my $db = DBI->connect($d, $u, $p);
# クライアント側文字コードの指定
$db->do("set names utf8"); 

if(!$db){
    print "接続失敗\n";
    exit;
}

# SQL文を用意
my $sth = $db->prepare("select id,userid,memo,tag,fromtime,totime,days from RemainderMemo");

#取得されるべき値
#my $min = 12;#given
#my $hour = 17;#given
#my $days = "Sun,Mon,Wed,Sat";#given

if(!$sth->execute){
    print "SQL失敗\n";
    exit;
}

while (my @rec = $sth->fetchrow_array) {
#    print "$rec[0]\n";    #id
#    print "$rec[1]\n";    #userid
    print "$rec[2]\n";    #memo
#    print "$rec[3]\n";    #tag
#    print "$rec[4]\n";    #fromtime
    my @fromminhour= split(/\s|:/,$rec[4]);
    #hour:$minhour[1],min:$minhour[2]
#    print "$rec[5]\n";    #totime
#    print "$rec[6]\n";    #days
    my @days= split(/,/,$rec[6]);
#    print "\n";
}

# ステートメントハンドルオブジェクトを閉じる
$sth->finish;
# データベースハンドルオブジェクトを閉じる
$db->disconnect;
