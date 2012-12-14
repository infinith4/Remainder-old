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

sub job{
# 実行したい処理（メール送信、時間設定ファイルの読み込み？）
    print "job:$_[0]\n";
}

my $cron = new Schedule::Cron(\&dispatcher);

my @aaa = ("aaa","bbb","ccc");


my @min = (54,55,56);

#my @memos;

#push(@memos,$memo);

#monday
$cron->add_entry("0 8 * * * ", \&job(@memo));
$cron->add_entry("0 12 * * * ", \&job(@memo));
$cron->add_entry("0 15 * * * ", \&job(@memo));
$cron->add_entry("0 21 * * * ", \&job(@memo));

=pod
#monday
$cron->add_entry("0 8 * * * ", \&job(@memo));
#tuesday
$cron->add_entry("$_ 23 * * * ", \&job($_));
#wednesday
$cron->add_entry("$_ 23 * * * ", \&job($_));
#thursday
$cron->add_entry("$_ 23 * * * ", \&job($_));
#friday
$cron->add_entry("$_ 23 * * * ", \&job($_));
#starday
$cron->add_entry("$_ 23 * * * ", \&job($_));
#sunday
$cron->add_entry("$_ 23 * * * ", \&job($_));
=cut

$cron->run();
