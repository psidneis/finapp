$(document).on('click', '.accounts_general', function(){
	$('.accounts_details').slideToggle('slow', function(){
		if($('.accounts_general').find('i').hasClass('icon-chevron-down')) {
			$('.accounts_general').find('i').removeClass('icon-chevron-down');
			$('.accounts_general').find('i').addClass('icon-chevron-up');
		} else {
			$('.accounts_general').find('i').removeClass('icon-chevron-up');
			$('.accounts_general').find('i').addClass('icon-chevron-down');
		}
	});
});