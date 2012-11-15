$(function(){
	
	// アラートボックスのHTML
	var $alertBox = $('<a href="#" class="alertBox"></a>');
	
	// フォームの送信時
	$('form').submit(function(){
		
		$alertBox
			.clone(true)
			.text('送信完了しました。ありがとうございました。')
			.hide().appendTo('body').slideDown()
			.delay(5000).fadeOut();
				
		return false;
	});
	
	// クリックでフェードアウト
	$alertBox
		.click(function(){
			$(this).stop(true).fadeOut();
			return false;
		});
	
});
