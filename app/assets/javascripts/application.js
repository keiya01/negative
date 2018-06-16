// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery.infinitescroll
//= require social-share-button
//= require rails-ujs
//= require turbolinks
//= require_tree .

$(document).on('turbolinks:load', function() {
	// delete modal
	$('.post-box').on('click', function(){
		var $id = $(this).data('id');
		var $question = $(this).data('question');
		$('#delete-modal').find('form').attr('action', '/posts/'+$id+'/check');
		$('#delete-modal').find('textarea').attr('placeholder', '問題： '+$question);
		$('#delete-modal-form').show();
		$('#delete-modal-form').addClass('active');
		$('html, body').css('overflow', 'hidden');
	});
	$('.undelete-btn').on('click', function(){
		$('#delete-modal-form').hide();
		$('#delete-modal-form').removeClass('active');
	    $('html, body').css('overflow', 'auto');
	});

	//regist-modal
	$('.self-regist-btn').on('click', function(){
		$('#user-regist-modal').show();
		$('#user-regist-modal').addClass('active');
		$('html, body').css('overflow', 'hidden');
	});
	$('.unregist-btn').on('click', function(){
		$('#user-regist-modal').hide();
		$('#user-regist-modal').removeClass('active');
	    $('html, body').css('overflow', 'auto');
	});

	// closed modal
	function closedModal(modal){
		$('.modal').on('click', function(e){
			var setModal = $(e.target).find(modal);
			console.log(setModal);
			if($('.modal').hasClass('active') && !$(e.target).closest(setModal).length && setModal.length){
				$('.modal').hide();
				$('.modal').removeClass('active');
				$('html, body').css('overflow', 'auto');
			}
		});
	}
	closedModal('#delete-modal');
	closedModal('#regist-modal');

	// flash
	function headerFlash(flash){
		if($(flash).length){
			$(flash).fadeIn(2000);
			setTimeout(function(){
				$(flash).fadeOut(1000);
			},3000);
		};
	};
	headerFlash("#flash-head");

	// 問題サンプル
	$('.question-sample-text').on('click',function(){
		var $questionText = $(this).data('question_text');
		$('#question-text').val($questionText);
	})

	// form val clean
	$('#new_comment').submit(function(){
		setTimeout(function(){
			$('#comment-text').val('');
		}, 1000)
	});

	// flickity
	$('#flickity-wrap').flickity({
 	   // ここでオプションを設定します。
    	wrapAround: true,
  		//　trueで無限スクロール。デフォルトはfalse。

		contain: true,
  	    //　trueでラッパー要素の中で収まるようにスクロールする。falseではみ出た部分に余白ができる。デフォルトはfalse。(wrapAround: trueの場合は無視される)

  		cellAlign: 'center',
   	    // セルの基準値を'center','left','right'で指定する。デフォルトは'center'。

        reseze: false,
        // falseでリサイズした時にサイズ変更しない。デフォルトはtrue。

        autoPlay: false
        // trueで3秒間隔で自動スクロール。秒数を指定したい場合は1500などミリ秒で指定する。デフォルトはfalse。

  });

	$('.self-image').on('change', function(){
		$('.self-image').addClass('select-image').text('ファイル選択中');
	});

});