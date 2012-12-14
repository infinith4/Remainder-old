#!/use/bin/perl
use strict;
use warnings;
use Schedule::Cron;
use Email::Sender::Simple qw(sendmail);
use Email::Simple;
use Email::Simple::Creator;
use Email::Sender::Transport::SMTP;

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

sub job0{
# 実行したい処理（メール送信、時間設定ファイルの読み込み？）
    print "job:$_[0]\n";
        
}
sub job1{
# 実行したい処理（メール送信、時間設定ファイルの読み込み？）
    print "job:$_[0]\n";
        
}
sub job2{
# 実行したい処理（メール送信、時間設定ファイルの読み込み？）
    print "job:$_[0]\n";
        
}

my $cron = new Schedule::Cron(\&dispatcher);

my @aaa = ("aaa","bbb","ccc");

my @min = (15,16,17);


    #$cron->add_entry("18 12 * * *", \&job); # 毎日午前10時から18時まで毎時0分に&job()を実行
    #$cron->add_entry("0-59/1 * * * *", \&job); # 10分ごとに&job()を実行
    $cron->add_entry("17 13 * * * 0-5/2", \&job0(15)); # 10分ごとに&job()を実行
    $cron->add_entry("18 13 * * * 0-5/2", \&job1(16)); # 10分ごとに&job()を実行
    $cron->add_entry("19 13 * * * 0-5/2", \&job2(17)); # 10分ごとに&job()を実行
$cron->run();
