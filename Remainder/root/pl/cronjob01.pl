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
#    print "job";
}

sub job{
# 実行したい処理（メール送信、時間設定ファイルの読み込み？）
    #mail 送信
    my $email = Email::Simple->create(
        header => [
            From    => '"from name" <infinith4@gmail.com>',
            To      => '"to name" <infith4@math.tsukuba.ac.jp>',
            Subject => "testmemo mail subject",
        ],
        body => "Job test\n",
        );

    my $transport = Email::Sender::Transport::SMTP->new({
        ssl  => 1,
        host => 'smtp.gmail.com',
        port => 465,
        sasl_username => 'infinith4@gmail.com',
        sasl_password => 'pallallp5'
    });
    eval { sendmail($email, { transport => $transport }); };             
	if ($@) { warn $@ }


}

my $cron = new Schedule::Cron(\&dispatcher);
$cron->add_entry("0 10-18 * * *", \&job); # 毎日午前10時から18時まで毎時0分に&job()を実行
$cron->add_entry("0-59/1 * * * *", \&job); # 10分ごとに&job()を実行
$cron->run();
