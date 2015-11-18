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