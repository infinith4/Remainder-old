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
my $userid ="tashirohiro4";
my $usermail = "infinith4\@gmail.com";
my $subject = "[test] Remainder";
=pod
my $mailcontent = <<'EOF';
<html>
Content

Tag

<a href="http://localhost:3000/memo">配信を停止する</a>
<hr>
- Remainder -あなたの気になるをお知らせ-
remainder.information\@gmail.com
</html>
EOF
=cut
my $mailcontent = <<'EOF';

Content

Tag

配信を停止する(http://localhost:3000/memo)
-------------------------------------------
- Remainder -あなたの気になるをお知らせ-
remainder.information@gmail.com

EOF
my $frommail = "remainder.information\@gmail.com";
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
            From    => '"Mail Remainder"'." <".$frommail.">",
            To      => $userid."さん"." <".$usermail.">",#given
            Subject => "$subject",#given
        ],
        body => "$mailcontent",#given
        );

    my $transport = Email::Sender::Transport::SMTP->new({
        ssl  => 1,
        host => 'smtp.gmail.com',
        port => 465,
        sasl_username => $frommail,
        sasl_password => $frommailpassword
                                                        });
    eval { sendmail($email, { transport => $transport }); };             
    if ($@) { warn $@ }

}


for
my $cron = new Schedule::Cron(\&dispatcher);

my $min = 14;#given
my $hour = 22;#given
my $days = "Sun,Mon,Wed,Sat";#given

my @daylist = split(/,/,$days);

if(scalar(@daylist) != 0){
    for(my $i = 0;$i < scalar(@daylist);$i++){
        $cron->add_entry("$min $hour * * $daylist[$i]", \&job);
    }
}

$cron->add_entry("0-59/1 * * * *", \&job);

$cron->run();

#mail送信 END ################################################



