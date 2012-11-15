$(function(){
	
	var $ul = $('#gallery');  // #gallery内のulを取得
	var $li = $ul.find('li'); // $ul内のliを取得
	
	var lw = $li.width();  // リスト要素の幅
	var lh = $li.height(); // リスト要素の高さ
	var m = 15;  // リスト要素同士の最小の間隔
	var s = 500; // アニメーションの時間（ミリ秒）
	var initWidth = $ul.width();   // ulのデフォルトの幅
	var initHeight = $ul.height(); // ulのデフォルトの高さ
	
	// 初期化
	function init() {
		
		// 絶対配置に切り替え
		$ul.addClass('jsReady');
		
		// リスト要素をulの中央に配置
		$li.css({
			'left': ( initWidth - lw ) * 0.5,
			'top': ( initHeight - lh ) * 0.5
		});
	}
	
	// リスト要素を整列させる関数
	function layout() {
		
		
		// ulの幅を取得
		var uw = initWidth || $ul.width();
		
		// リスト要素の列数、行数を算出
		var cols = Math.floor( ( uw + m ) / ( lw + m ) );
		var rows = Math.ceil( $li.size() / cols );
		
		// リスト要素間の余白を算出
		var _m = Math.floor( ( uw - cols * lw ) / ( cols + 1 ) );
		
		// ulの高さを修正
		$ul.css({ 'height': rows * ( lh + _m ) - _m });
		
		// リスト要素の次の位置を計算し、そこまでアニメーションさせる
		$li.each(function(i){
			
			$(this)
				.stop(true) // 前回のアニメーションをキャンセル
				.animate({
						'left': Math.round(( i % cols ) * ( lw + _m )) + _m,
						'top': Math.floor( i / cols ) * ( lh + _m )
					}, s, 'easeInOutExpo' );
		});
		
		// 変数の中身を破棄
		initWidth = undefined;
	}
	
	// イベントの登録
	$(window).bind('load resize', layout);
	
	// 初期化実行
	init();
	
});
