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
		$('#modal').show();
		$('html, body').css('overflow', 'hidden');
	});
	$('.undelete-btn').on('click', function(){
		$('#modal').hide();
	    $('html, body').css('overflow', 'auto');
	});

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

	$('.question-sample-text').on('click',function(){
		var $questionText = $(this).data('question_text');
		$('#question-text').val($questionText);
	})
});