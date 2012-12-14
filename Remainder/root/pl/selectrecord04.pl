#!/usr/bin/perl

use strict;
use warnings;

use Schedule::Cron;

use DBI;
use Email::Sender::Simple qw(sendmail);
use Email::Simple;
use Email::Simple::Creator;
use Email::Sender::Transport::SMTP;
use DateTime;

#script/reamainder_server.pl とは別に、メール送信用にscriptを走らせておく。

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

my $dt = DateTime->now( time_zone => 'Asia/Tokyo' );
my  $dayabbr    = $dt->day_abbr;   # 曜日の省略名
$dt =~ s/T/ /g;

#print $dt;
# SQL文を用意
#                              0   1      2    3    4        5     6
my $sth = $db->prepare("SELECT id,userid,memo,tag,fromtime,totime,days FROM RemainderMemo WHERE '$dt' >= fromtime and days like '%$dayabbr%' ORDER BY fromtime asc"); #fromtime でソート.現在以前
#取得されるべき値
#my $min = 12;#given
#my $hour = 17;#given
#my $days = "Sun,Mon,Wed,Sat";#given

if(!$sth->execute){
    print "SQL失敗\n";
    exit;
}

    my @memos;

while (my @rec = $sth->fetchrow_array) {
    push(@memos,$rec[2]);
}

foreach (@memos) {
    print "$_\n";
}

=pod
while (my @rec = $sth->fetchrow_array) {
    my $fromtime = $rec[4];
    my $totime = $rec[5];
    my $days = $rec[6];
    print $fromtime,"\n";#All fromtime entrys display
}
=cut

my $subject = "[test] Reminder";
my $frommail = "reminder.information\@gmail.com";
my $frommailpassword = "ol12dcdbl0jse1l";

sub sendmaildispatcher{
    print "ID: ", shift, "\n";
    print "Args:","@_", "\n";
}

sub sendmailjob{#mail 送信job
    #mail 送信
    my $useridsendmail = $_[0];
    my $usermailsendmail = $_[1];
    my @arr = @_;
    
#    print "$arr[0]\n";
#    print "$arr[1]\n";

=pod
    my $mailcontent = "$useridsendmail さん\n\n-----------------------------------------------\n - Remainder -あなたの気になるをお知らせ-\n $frommail";

    my $email = Email::Simple->create(
        header => [
            From    => '"Mail Remainder"'." <".$frommail.">",
            To      => $useridsendmail."さん"." <".$usermailsendmail.">",#given
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
=cut

}


#    my @daylist = split(/,/,$days);

#my $cron;
my $cron = new Schedule::Cron(\&sendmaildispatcher);

=pod
while (my @rec = $sth->fetchrow_array) {
    
    my @fromminhour = split(/\s|:/,$rec[4]);
    my @days = split(/,/,$rec[6]);

    my $min = $fromminhour[1];#given
    my $hour = $fromminhour[2];#given
    my $days = $rec[6];#given
    my $userid =$rec[1];#given
    my $usermail = "infinith4\@gmail.com";#given
    print "$hour:$min\n";

    $cron->add_entry("05 00 * * Mon", \&sendmailjob($userid,$usermail));


}
=cut

    my $userid ="tashirohiro4";#given
    my $usermail = "infinith4\@gmail.com";#given

=pod
    $cron->add_entry("0 8 * * *", \&sendmailjob($userid,$usermail,@memos));
    $cron->add_entry("0 12 * * *", \&sendmailjob($userid,$usermail,@memos));
    $cron->add_entry("0 15 * * *", \&sendmailjob($userid,$usermail,@memos));
    $cron->add_entry("0 21 * * *", \&sendmailjob($userid,$usermail,@memos));
=cut
    $cron->add_entry("2 21 * * *", \&sendmailjob($userid,$usermail,@memos));
#    $cron->add_entry("26 00 * * Mon", \&sendmailjob($userid,$usermail));
 
    $cron->run();

    #$cron->add_entry("0-59/1 * * * *", \&job);



#mail送信 END ################################################

# ステートメントハンドルオブジェクトを閉じる
$sth->finish;
# データベースハンドルオブジェクトを閉じる
$db->disconnect;
