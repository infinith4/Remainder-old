use strict;
use warnings;

use DateTime;

#日付を指定して生成
my $dt = DateTime->new(
    time_zone => 'Asia/Tokyo',
    year      => 2008,
    month     => 8,
    day       => 4,
    hour      => 15,
    minute    => 0,
    second    => 0
    );

#epochから生成
$dt = DateTime->from_epoch( time_zone => 'Asia/Tokyo', epoch => 1217829600 );
print $dt,"\n";
#現在の日付(時間ふくむ)
$dt = DateTime->now( time_zone => 'Asia/Tokyo' );
print $dt->hour,"\n";

print $dt,"\n";

$dt=$dt->add(months => 12);
print $dt,"\n";

#現在の日付(時間含まない)
$dt = DateTime->today( time_zone => 'Asia/Tokyo' );
print $dt,"\n";

#月末 2008-08-31T00:00:00
$dt = DateTime->last_day_of_month( year => 2008, month => 8 );

print $dt,"\n";
#2008年正月から250日目 2008-09-06T00:00:00
$dt = DateTime->from_day_of_year( year => 2008,day_of_year => 360 );

print "aaa",$dt,"\n";

#月末日を取得
my $dt2 = DateTime->last_day_of_month( year => 2013, month => 2 );
print "2013年2月の月末日は", $dt2->day, "日です。\n";
