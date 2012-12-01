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
            To      => '"to name" <remainder.infomation@gmail.com>',
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
#$cron->add_entry("0-59/1 * * * *", \&job); # 1分ごとに&job()を実行
$cron->add_entry("50 15 * * * 0-30/2", \&job); # 10分ごとに&job()を実行
my $min = 12;
my $hour = 17;
my $days = "Sun,Mon,Wed,Sat";#Sun,Mon,Wed,Sat
my @daylist = split(/,/,$days);

#switch day

#$cron->add_entry("40 16 * * Sat", \&job);
#print scalar(@daylist),"\n";

for(my $i = 0;$i < scalar(@daylist);$i++){
    $cron->add_entry("$min $hour * * $daylist[$i]", \&job);
}

#$cron->add_entry("0-59/1 * * * *", \&job); # 10分ごとに&job()を実行
$cron->run();
