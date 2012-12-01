#!/usr/bin/perl

use strict;
use warnings;

use Schedule::Cron;

use DBI;
use Email::Sender::Simple qw(sendmail);
use Email::Simple;
use Email::Simple::Creator;
use Email::Sender::Transport::SMTP;

#script/reamainder_server.pl とは別に、メール送信用にscriptを走らせておく。
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
    #必要なデータはmysqlから呼び出す。
    my $userid ="tashirohiro4";#given
    my $usermail = "infinith4\@gmail.com";#given
    my $subject = "[test] Remainder";

    my $frommail = "remainder.information\@gmail.com";
    my $frommailpassword = "ol12dcdbl0jse1l";
=pod
    my $mailcontent = <<'EOF';
$userid さん
Content:$rec[2]

Tag:$rec[3]

$rec[4]から$rec[5]まで配信されます.($rec[6])

配信を停止する(http://localhost:3000/memo)
-----------------------------------------------
 - Remainder -あなたの気になるをお知らせ-
 remainder.information@gmail.com
EOF
=cut

    my $mailcontent = "$userid さん\n\nContent:$rec[2]\n\nTag:$rec[3]\n$rec[4]から$rec[5]まで配信されます.($rec[6])\n\n配信を停止する(http://localhost:3000/memo)\n\n-----------------------------------------------\n - Remainder -あなたの気になるをお知らせ-\n $frommail";

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

    #    print "$rec[0]\n";    #id
    #    print "$rec[1]\n";    #userid
    #    print "$rec[2]\n";    #memo
    #    print "$rec[3]\n";    #tag
    #    print "$rec[4]\n";    #fromtime
    my @fromminhour= split(/\s|:/,$rec[4]);
    #hour:$minhour[1],min:$minhour[2]
    #    print "$rec[5]\n";    #totime
    #    print "$rec[6]\n";    #days
    my @days= split(/,/,$rec[6]);
    #    print "\n";
    my $cron = new Schedule::Cron(\&dispatcher);

    my $min = $fromminhour[1];#given
    my $hour = $fromminhour[2];#given
    my $days = $rec[6];#given

    my @daylist = split(/,/,$days);

    if(scalar(@daylist) != 0){
        for(my $i = 0;$i < scalar(@daylist);$i++){
            $cron->add_entry("$min $hour * * $daylist[$i]", \&job);
        }
    }

    #$cron->add_entry("0-59/1 * * * *", \&job);

    $cron->run();

}

#mail送信 END ################################################

# ステートメントハンドルオブジェクトを閉じる
$sth->finish;
# データベースハンドルオブジェクトを閉じる
$db->disconnect;
