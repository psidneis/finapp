// $(document).ready(function() {
// });

$(document).on('page:change', function(event) {
  $(".datepicker_button").datetimepicker({ format: 'DD/MM/YYYY HH:mm' });

  $('input.format_value').priceFormat({
    prefix: 'R$ ',
    centsSeparator: ',',
    thousandsSeparator: '.'
  });

});