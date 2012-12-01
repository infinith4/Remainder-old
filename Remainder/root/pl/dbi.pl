#!/usr/bin/perl

use strict;
use warnings;

use DBI;

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

# SQL文を用意
my $sth = $db->prepare("select id,memo from RemainderMemo");

#取得されるべき値
#my $min = 12;#given
#my $hour = 17;#given
#my $days = "Sun,Mon,Wed,Sat";#given



if(!$sth->execute){
    print "SQL失敗\n";
    exit;
}

while (my @rec = $sth->fetchrow_array) {
    print "$rec[0]\n";
    print "$rec[1]\n";
}

# ステートメントハンドルオブジェクトを閉じる
$sth->finish;
# データベースハンドルオブジェクトを閉じる
$db->disconnect;
