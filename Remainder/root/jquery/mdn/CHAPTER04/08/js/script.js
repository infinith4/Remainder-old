$(function(){
	
	// ボックスの高さの最大値を
	// 格納する変数
	var maxHeight = 0;
	
	// 高さをそろえたいボックスを列挙
	$('#news, #release').each(function(){
		
		// ボックスの高さを取得して
		// 最大値と比較する
		var height = $(this).height();
		maxHeight = Math.max(maxHeight, height);
		
	}).height(maxHeight);
		
});
