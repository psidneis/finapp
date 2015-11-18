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
    },
    buttonIcons: {
      prev: 'left-single-arrow',
      next: 'right-single-arrow'
    },
    
    events: function(start, end, timezone, callback) {
      $.ajax({
        url: calendar_url,
        dataType: 'json',
        data: {
          start_date: start.format(),
          end_date: end.format(),
        },
        success: function(doc) {
          var events = [];
          $(doc).each(function() {
            events.push({
              id: $(this)[0].id,
              title: $(this)[0].title,
              editable: false,
              start: moment($(this)[0].date).format(),
              end: moment($(this)[0].date).add(60, 'minutes').format(),
              backgroundColor: '#49bf67'
            });
          });
          callback(events);
        }
      });
    }    

  })

});

$(document).on("page:restore page:load ready", function() {
  var placeholder = $("#pie_chart");
  var placeholder_url = placeholder.attr('data-url');
  var data = [];

  $.ajax({
    url: placeholder_url,
    dataType: 'json',
    data: {
      start_date: moment($('li.previous').attr('data-value')).format(),
      end_date: moment($('li.next').attr('data-value')).format(),
    },
    success: function(doc) {
      $(doc).each(function() {
        var obj = {};
        obj['label'] = $(this)[0].title + ' - ' + $(this)[0].total_value;
        obj['data'] = parseFloat($(this)[0].percentage);
        obj['color'] = $(this)[0].color;
        data.push(obj);
      });

      $.plot(placeholder, data, {
        series: {
          pie: {
            show: true,             
            label: {
              show:true,
              radius: 0.8,
              formatter: function (label, series) {                
                return '<div style="border:1px solid grey;font-size:8pt;text-align:center;padding:5px;color:white;opacity: 0.8;background: #000">' +
                label + ' : ' +
                Math.round(series.percent) +
                '%</div>';
              },       
            }
          }
        },
        grid: {
          hoverable: true,
          clickable: true
        }
      });
    }
  });

});