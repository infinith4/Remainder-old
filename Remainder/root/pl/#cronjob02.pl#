#!/use/bin/perl
use strict;
use warnings;
use Schedule::Cron;

sub dispatcher{
    print "ID: ", shift, "\n";
    print "Args:","@_", "\n";
}

sub job{
# 実行したい処理（メール送信、時間設定ファイルの読み込み？）
    print "job:$_[0]\n";
}

#ダメな例 jobに引数を与えると、即実行される

my $aaa = "aaaa";
my $cron = new Schedule::Cron(\&dispatcher);
$cron->add_entry("1 22 * * * ", &job($aaa)); # 毎日午前10時から18時まで毎時0分に&job()を実行
$cron->add_entry("37 23 * * * ", \&job); # 10分ごとに&job()を実行
$cron->run();
