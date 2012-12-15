#!/usr/bin/perl
use strict;
use warnings;
use DateTime;
use DBI;
use Email::Sender::Simple qw(sendmail);
use Email::Simple;
use Email::Simple::Creator;
use Email::Sender::Transport::SMTP;
use utf8;
use Encode qw/decode/;

#ここまでで複数時間を指定してメールを時間に送信できる。

#DBからselect してmemoと時間を指定するだけ。

my $dtnow = DateTime->now( time_zone => 'Asia/Tokyo' );
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
$db->do("set names utf8"); 
# SQL文を用意
#                              0   1      2    3    4        5     6
#my $sth = $db->prepare("SELECT id,userid,memo,tag,fromtime,totime,days FROM RemainderMemo WHERE '$dtnow' >= fromtime and days like '%$dayabbr%' ORDER BY fromtime asc"); #fromtime でソート.現在以前
my $sth = $db->prepare("SELECT id,userid,memo,tag,fromtime,totime,days FROM RemainderMemo WHERE '$dtnow' >= fromtime ORDER BY fromtime asc"); #fromtime でソート.現在以前

if(!$sth->execute){
    print "SQL失敗\n";
    exit;
}

#my $time = "2012-12-02 11:49:00";

my @memos = ();
my @hours = ();
my @mins = ();

while (my @rec = $sth->fetchrow_array) {
    my $fromtime = $rec[4];
    print $fromtime,"\n";
    $fromtime =~ m/\s/;
    my $hourminsec = "$'";

    print $hourminsec,"\n";

    my @arr =split(/:/,$hourminsec);

    push(@hours,$arr[0]);
    push(@mins,$arr[1]);

    push(@memos,$rec[2]);
}

foreach(@memos){
    # バイト文字列(外部からの入力)を内部文字列に変換($strがUTF-8の場合)
   # my $str = decode('UTF-8', $_);
    print $_,"\n";
}

=pod
#DB から取得されるべき値
#時間は要素ごとに対応している。
my @hours = (5,5,9);
my @mins = (36,37,28);
=cut

my $hoursnum = scalar(@hours);

sub hourmin_entry{
    my ($hours,$mins,$hash,@memos) = @_;
    
    for (my $i=0;$i<$hoursnum;$i++){
            print "select time is ",$$hours[$i],$$mins[$i],"\n";
    }
    my $frommail = "remainder.information\@gmail.com";
    my $frommailpassword = "ol12dcdbl0jse1l";

    while(1){
        my $dt = DateTime->now( time_zone => 'Asia/Tokyo' );
        #my $hour = $dt->hour(),"\n";
        #my $min = $dt->minute(),"\n";
        print $dt,"\n";
        
        my $content = "";
        foreach(@memos){
                $content = $content.$_."\n";
        }
        #print $content,"\n";
        for(my $i =0;$i < $hoursnum;$i++){
        
                if(($$hours[$i] == $dt->hour()) && ($$mins[$i] == $dt->minute()) ){
                    #$func;
                    #last;

                    #sendmailjob
                    print "sendmail\n";
                    print $$hash{userid},"\n";
                    my $mailcontent = "$$hash{userid} さん\n\n内容:\n$content\n\n配信を停止する(http://localhost:3000/memo)\n\n-----------------------------------------------\n - Remainder -あなたの気になるをお知らせ-\n $frommail";

                    #print $$hash{userid},"\n";
                    #mail 送信
                    my $email = Email::Simple->create(
                        header => [
                            From    => '"Mail Remainder"'." <".$frommail.">",
                            To      => $$hash{userid}."さん"." <".$$hash{usermail}.">",#given
                            Subject => "$$hash{subject}",#given
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
                
        }
        sleep(60);
    }
    
}


my @aaa=("aaa","bbb");

my $bbb="bbb";
my $userid ="tashirohiro4";#given
my $usermail = "infinith4\@gmail.com";#given
my $subject = "[test] Remainder";
#my @memos = ("memo1","memo2","memo3");



my %hash = ( userid => $userid, usermail => $usermail, subject => $subject);

#if文が適用されていない

&hourmin_entry(\@hours,\@mins,\%hash,@memos);

#1;


# ステートメントハンドルオブジェクトを閉じる
$sth->finish;
# データベースハンドルオブジェクトを閉じる
$db->disconnect;
