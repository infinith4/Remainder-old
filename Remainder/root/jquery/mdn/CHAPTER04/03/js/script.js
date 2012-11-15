$(function(){
	
	var $twtr = $('#twitter');
	
	// Ajaxステータスの表示
	$twtr.empty()
		.append('<p class="msg">ツイートの取得中…</p>');
	
	$.getJSON( 'http://api.twitter.com/1/favorites/OnePixelRecords.json?callback=?&count=6' )
		
		// 読み込み完了時
		.success(function( json ) {
			
			var tweetStr = ''; // ツイートHTML格納用
			var time, icon, name, text;
			
			// divを空に
			$twtr.empty();
			
			// JSONデータの処理
			$.each( json, function(i, tweet) {
				
				// JSONからデータを抽出
				name = tweet.user.screen_name;       // ユーザー名
				time = tweet.created_at;             // 日付
				icon = tweet.user.profile_image_url; // プロフィールアイコンURL
				text = tweet.text;                   // ツイート本文
				
				// 日付のフォーマット
				time = formatDate(time);
				
				// プロフィールアイコン（最少サイズを使用）
				icon = icon.replace(/_normal/, '_mini');
				
				// ツイート内のリンク／ユーザー名／ハッシュタグ
				text = text.replace(/(s?https?:\/\/[-_.!~*'()a-zA-Z0-9;\/?:\@&=+\$,%#]+)/gi, '<a href="$1" class="link">$1</a>');
				text = text.replace(/#(\w+)/gi,'<a href="http://twitter.com/#!/search?q=%23$1" class="hashtag">#$1</a>' );
				text = text.replace(/@(\w+)/gi,'<a href="http://twitter.com/#!/$1" class="user">@$1</a>' );
				
				// HTMLの整形
				tweetStr += '<li>';
				tweetStr += '<span class="time">' + time + '</span>';
				tweetStr += '<span class="icon"><a href="http://twitter.com/#!/' + name + '">'
				   + '<img src="' + icon + '" alt="' + name + '" width="24" height="24" /></a></span>';
				tweetStr += '<span class="name">' + name + '</span>';
				tweetStr += '<span class="text">' + text + '</span>';
				tweetStr += '</li>';
				
			});
			
			// HTMLを追加
			$('<ul></ul>').html(tweetStr).appendTo($twtr);
		})
		
		// 読み込みエラー時
		.error(function( json ) {
			$twtr.empty()
				.append('<p class="error">エラー：ツイートを取得できませんでした。</p>');
		});
	
	// 日付フォーマット用関数
	function formatDate( date ) {
		
		var dArr, dStr, d;
		
		// IEでパースできないフォーマットのため、
		// 文字列の順序を入れ替える
		dArr = date.split(" ");
		dStr = [dArr[0], dArr[1], dArr[2], dArr[5], dArr[3], dArr[4]].join(' ');
		d = new Date(dStr);
		
		return d.getFullYear() + '/' + (d.getMonth()+1) + '/' + d.getDate();
		
	}
			
});
