/* 設定 */
var setting = {
	feed_url:'http://cafemenu.net/menu.php?callback=?',
	like_threshold:1//この値以上の「いいね」で、サムネイルを拡大表示
};

/* Masonryの手動更新 */
function masonry_update(){
	$('div#cover').masonry({itemSelector:'li', columnWidth:160});
};

/* カバーページの表示 */
function showCover(){
	$('div#cover').animate({width:960,left:15}, masonry_update);
	$('div.page').fadeOut();
	$('a#goto_menu').addClass('disabled');
	$('body').removeClass('detail');
};

/* 詳細ページの表示 */
function showPage(id){
	$('div#cover').animate({width:320,left:655}, masonry_update);
	$('div.page').fadeOut();
	$('div#page_'+id).fadeIn();
	$('a#goto_menu').removeClass('disabled');
	$('body').addClass('detail');
};

/* URL文字列を検出して、リンクにする */
String.prototype.autoLink = function(){
	return this.replace(/(https?:\/\/[^\s]+)/g, function(){
	    return '<a href="' + arguments[1] + '">' + decodeURI(arguments[1]) + '</a>';
	});
};

/* 文字列の前後の空白を除去 */
String.prototype.trim = function(){
	return this.replace(/^\s+|\s+$/g, '');
};

/* フィードを読込む */
$(function(){
	$.getJSON(setting.feed_url, function(json){
		var photos = json.data, cover = [], pages = [], titles = [], shop_name;
		
		cover.push('<ul>');
		for (var i = 0; i < photos.length; i++){
			var d = new Date(), arr, title, desc, size;
			if (typeof photos[i].name == 'undefined') continue;//タイトル未設定の場合はスキップ
			if (typeof shop_name == 'undefined') shop_name = photos[i].from.name;
			d.setTime(photos[i].created_time*1000);
			//1行目をタイトルとして分離
			arr = photos[i].name.split('\n');
			title = arr.shift().trim();
			desc = arr.join('\n').trim().replace(/\n/g, '<br />');
			//「いいね」が一定値以上で、サムネイルを大きく
			size = (photos[i].likes >= setting.like_threshold) ? 'L' : 'S';
			//メニュー項目の重複を除去
			if ($.inArray(title, titles) > -1) continue;
			titles.push(title);
			//HTMLの構築
			cover.push(
				'<li class="', size, '">',
					'<a href="#/page/', photos[i].id, '">',
						'<img src="', size=='L'?photos[i].source:photos[i].picture, '" alt="', title, 'のサムネイル" />',
						'<span>', title, '</span>',
					'</a>',
				'</li>');
			pages.push(
				'<div class="page" id="page_', photos[i].id, '">',
					'<div class="photo"><a href="', photos[i].link, '"><img src="', photos[i].source, '" alt="', title, 'の写真" /></a></div>',
					'<h3>', title, '</h3>',
					'<p>', desc ? desc.autoLink() : '(執筆中...)', '</p>',
				'</div>');
		}
		cover.push('</ul>');
		
		document.title = shop_name;
		$('div#header h1').text(shop_name);
		$('div#cover').html(cover.join(''));
		$('div#pages').html(pages.join(''));
		
		$('div#cover').imagesLoaded(masonry_update);
		
		//ルーティング
		var router = Router({
			'/cover': showCover,
			'/page': {
				'/(\\w+)': showPage
			}
		}).init();
	});
});