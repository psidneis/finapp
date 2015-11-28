$(document).on('change', '.recurrence_type_input', function(){
	input_chosen = $(this).find('input').val();
	text_chosen = $(this).text()
	if(input_chosen == 'installments'){
		$('#amount_installment_input').show();
		$('#recurrence_input').show();
	} else if(input_chosen == 'recurrence'){
		$('#amount_installment_input').hide();
		$('#recurrence_input').show();
	} else {
		$('#amount_installment_input').hide();
		$('#recurrence_input').hide();
	}	
	$('#recurrence_type_chosen').html(text_chosen);
});

$(document).on('click', '.paid_input_icon', function(){
	if($(this).data('paid') == 'not_paid'){
		$(this).data('paid', 'paid');
		$(this).removeClass('icon-thumbs-down-alt');
		$(this).removeClass('text-red');
		$(this).addClass('icon-thumbs-up-alt');
		$(this).addClass('text-green');
		$(this).prop('title', $(this).data('title-not-paid'))
	}else{
		$(this).data('paid', 'not_paid');
		$(this).removeClass('icon-thumbs-up-alt');
		$(this).removeClass('text-gren');
		$(this).addClass('icon-thumbs-down-alt');
		$(this).addClass('text-red');
		$(this).prop('title', $(this).data('title-paid'))
	}
});