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
    print "job";
}

my $cron = new Schedule::Cron(\&dispatcher);
$cron->add_entry("0 10-18 * * *", \&job); # 毎日午前10時から18時まで毎時0分に&job()を実行
$cron->add_entry("0-59/100 * * * *", \&job); # 10分ごとに&job()を実行
$cron->run();
