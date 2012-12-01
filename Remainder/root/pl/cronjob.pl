#!/usr/bin/perl

use strict;
use warnings;

use Schedule::Cron;

use Email::Sender::Simple qw(sendmail);
use Email::Simple;
use Email::Simple::Creator;
use Email::Sender::Transport::SMTP;

#script/reamainder_server.pl とは別に、メール送信用にscriptを走らせておく。
#必要なデータはmysqlから呼び出す。

my $usermail = "remainder.infomation@gmail.com";
my $subject = "testmemo mail subject";
my $mailcontent = <<'EOF';
body1
body2
body3
body4
body5
body6
body7
body8
EOF

my $frommail = "remainder.information@gmail.com";
my $frommailpassword = "ol12dcdbl0jse1l";

#mail 送信 START #########################################
sub dispatcher{
    print "ID: ", shift, "\n";
    print "Args:","@_", "\n";
}

sub job{#mail 送信job
    #mail 送信
    my $email = Email::Simple->create(
        header => [
            From    => '"from name" <$frommail>',
            To      => '"to name" <$usermail>',#given
            Subject => "$subject",#given
        ],
        body => "$mailcontent",#given
        );

    my $transport = Email::Sender::Transport::SMTP->new({
        ssl  => 1,
        host => 'smtp.gmail.com',
        port => 465,
        sasl_username => '$frommail',
        sasl_password => '$frommailpassword'
                                                        });
    eval { sendmail($email, { transport => $transport }); };             
    if ($@) { warn $@ }

}

my $cron = new Schedule::Cron(\&dispatcher);

my $min = 12;#given
my $hour = 17;#given
my $days = "Sun,Mon,Wed,Sat";#given

my @daylist = split(/,/,$days);

if(scalar(@daylist) != 0){
    for(my $i = 0;$i < scalar(@daylist);$i++){
        $cron->add_entry("$min $hour * * $daylist[$i]", \&job);
    }
}

$cron->run();

#mail送信 END ################################################



