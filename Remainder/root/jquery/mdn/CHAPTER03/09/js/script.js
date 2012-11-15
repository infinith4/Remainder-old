$(function(){
	
	// デフォルトの背景色
	var defaultColor = '#eee';
	
	$('#banner li a')
		
		// オーバー時のカラーをdataに保存
		.each(function(){
			$(this).data('color', $(this).css('background-color'));
		})
		
		// オーバー時の動作
		.hover(
			function() {
				$(this).stop(true).animate({
					'background-color': $(this).data('color')
				}, 200, 'swing');
			},
			function() {
				$(this).stop(true).animate({
					'background-color': defaultColor
				}, 400, 'swing');
			}
		)
		
		// 背景色をデフォルトのカラーに
		.css('background-color', defaultColor);
		
});
