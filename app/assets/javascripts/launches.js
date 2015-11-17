$(document).on('change', '.recurrence_type_input', function(){
	if($(this).find('input').val() == 'installments'){
		$('#amount_installment_input').show();
		$('#recurrence_input').show();
	} else if($(this).find('input').val() == 'recurrence'){
		$('#amount_installment_input').hide();
		$('#recurrence_input').show();
	} else {
		$('#amount_installment_input').hide();
		$('#recurrence_input').hide();
	}	
});