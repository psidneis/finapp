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

$(document).on('click', '.search_period_link', function(){
	context = $(this).data('context');
	data = {};
	if(context == 'navigation'){
		search_period = $(this).data('search-period');
		data = { search_period: search_period }
	} else if( context == 'period-chosen'){
		date_from = $('#datetimepicker_from').find('input').val();
		date_to = $('#datetimepicker_to').find('input').val();
		data = { start_date: date_from, end_date: date_to }
		$('#search_period_modal').modal('hide');
	}
	data['search_period_type'] = $(this).data('period-type');
	$.ajax({
	  url: $(this).data('url').toString(),
	  data: data,
	  dataType: 'script',
	  context: document.body,
	  beforeSend:function(){
	  	// $('.search_loading').show();
	  },
	  success:function() {
	  	// $('.search_loading').hide();
    },
    error:function(){
    	
    }
	});
	return false;
});

$(document).on('page:change ready', function(event) {
  $('#datetimepicker_from').datetimepicker({ format: 'DD/MM/YYYY HH:mm' });
  $('#datetimepicker_to').datetimepicker({
      useCurrent: false, format: 'DD/MM/YYYY HH:mm' //Important! See issue #1075
  });
  $("#datetimepicker_from").on("dp.change", function (e) {
      $('#datetimepicker_to').data("DateTimePicker").minDate(e.date);
  });
  $("#datetimepicker_to").on("dp.change", function (e) {
      $('#datetimepicker_from').data("DateTimePicker").maxDate(e.date);
  });
});

