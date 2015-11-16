$(document).on('change', '#recurrence_type_input', function(){
	if ($('#launch_recurrence_type').val() == 'installments'){
		$('#amount_installment_input').show()
		$('#recurency_input').show()
	} else if($('#launch_recurrence_type').val() == 'recurrence'){
		$('#amount_installment_input').hide()
		$('#recurency_input').show()
	} else {
		$('#amount_installment_input').hide()
		$('#recurency_input').hide()
	}
});