$(function(){
	
	// 商品をドラッガブルにする
	$('#itemCanvas .item')
		.draggable({
			cursor: 'pointer',
			revert: true
		});
	// カートをDroppableに
	$('#cartContainer')
		.droppable({
			activate: function(event, ui) {
				$(this).addClass('dropping');
			},
			deactivate: function(event, ui) {
				$(this).removeClass('dropping');
			},
			drop: function( event, ui ) {
				$(ui.draggable).detach().appendTo('#cartCanvas');
			}
		});
	// カートから戻す用にitemCanvsをDroppableにする
	$('#itemCanvas')
		.droppable({
			drop: function( event, ui ) {
				$(ui.draggable).detach().appendTo('#itemCanvas');
			}
		});
	
	// 数量変更時に金額を計算する
	$('.quantity').bind('textchange', function(event, previousText) {
		var $quantity = $(this);
		var $amount = $quantity.parent().find('.amount:first');
		if(isNaN($quantity.val())){
			$amount.val('<-数値を入力！');
		} else {
			var quantity = $quantity.val();
			var price = $quantity.parent().find('.price').attr('data-price');
			$amount.html((price*quantity)+'円');
		}
	});
});

