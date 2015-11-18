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

$(document).on('click', '#search_period_modal_link', function(){
	date_from = $('#datetimepicker_from').find('input').val();
	date_to = $('#datetimepicker_to').find('input').val();
	$('#search_period_modal').modal('toggle');
	$.get( $(this).data('url').toString(), { start_date: date_from, end_date: date_to, search_period_type: 'period' } );
});