$(function(){
	
	$('#uploadArea').droparea({
      post				: 'upload.php',
      instructions: '画像ファイルをドロップすると自動的にアップロードされ、ギャラリーに追加されます。',
			over        : 'そのままドロップして、この画像のアップロードをスタート！',
      complete		: function(r){
      	$('<a>')
      		.attr('href', r.filename)
      		.html(r.img)
      		.appendTo('#galleryArea')
      		.lightBox();
      }
  });
  
  $('#galleryArea').masonry({
    itemSelector : 'img'
  });
	
});

