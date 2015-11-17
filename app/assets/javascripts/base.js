$(document).on('page:change', function(event) {
  $(".datepicker_button").datetimepicker({ format: 'DD/MM/YYYY HH:mm' });

  $('input.format_value').priceFormat({
    prefix: 'R$ ',
    centsSeparator: ',',
    thousandsSeparator: '.'
  });

});

$(document).on("page:restore page:load ready", function() {
  calendar = $('#dashboard_calendar');
  var calendar_url = calendar.attr('data-url');
  calendar.fullCalendar({
    lang: 'pt-br',
    defaultView: 'month',
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month'
      // right: 'month,agendaWeek,agendaDay'
    },
    buttonIcons: {
      prev: 'left-single-arrow',
      next: 'right-single-arrow'
    },

    // eventClick: function(calEvent, jsEvent, view) {
    //   $.ajax({
    //     method: "GET",
    //     dataType: 'script',
    //     url: calEvent.url
    //   });
    //   return false;
    // },
    
    events: function(start, end, timezone, callback) {
      $.ajax({
        url: calendar_url,
        data: {
          start_date: start.format(),
          end_date: end.format(),
        },
        dataType: 'json',
        success: function(doc) {
          var events = [];
          $(doc).each(function() {
            events.push({
              id: $(this)[0].id,
              title: $(this)[0].title,
              editable: false,
              start: moment($(this)[0].date).format(),
              end: moment($(this)[0].date).add(60, 'minutes').format(),
              // url: $(this)[0].calendar_click_url,
              // backgroundColor: '#' + $(this)[0].calendar_background_color,
              // textColor: '#' + $(this)[0].calendar_text_color
            });
          });
          callback(events);
        }
      });
    }    

  })

});