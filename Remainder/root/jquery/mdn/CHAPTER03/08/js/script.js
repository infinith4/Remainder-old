$(function(){
	
	$('#nav li img').each(function(){
		
		var src, osrc;
		
		// 通常画像
		src = this.src;
		
		// オーバー画像
		osrc = src.replace(/(.+?)\.gif$/, '$1_ov.gif');
		
		// オーバー画像のプリロード
		(new Image).src = osrc;
		
		// 親要素にオーバー画像を指定
		$(this).parent().css('background', 'url(' + osrc + ')');
		
		// イベントの登録
		$(this).hover(
			function(){
				$(this).stop(true).animate({'opacity': 0},200,'swing');
			},
			function(){
				$(this).stop(true).animate({'opacity': 1},400,'swing');
			}
		);
		
	});
		
});
