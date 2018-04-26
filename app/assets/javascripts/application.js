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
//= require rails-ujs
//= require turbolinks
//= require_tree .

$(document).on('turbolinks:load', function() {
	// delete modal
	$('.post').on('click', function(){
		var $data = $(this).data('id');
		$('#delete-modal').find('form').attr('action', '/comments/'+$data+'/create');
		$('#modal').show();
		$('html, body').css('overflow', 'hidden');
	});
	$('.common-delete-btn').on('click', function(){
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
});