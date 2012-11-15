$(function(){
	
	// クリックイベントの登録
	$('#toPageTop a').click(function(){
		
		// ページトップへスクロール
		$('html, body').animate({
				'scrollTop': 0
			}, 900, 'easeInOutExpo');
		
		// デフォルトイベントのキャンセル
		return false;
	
	});
	
});
