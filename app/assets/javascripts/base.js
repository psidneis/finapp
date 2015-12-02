$(document).on('page:restore page:load ready', function(event) {
  datepicker();
  fullcalendar();
  pie_chart();
  bar_chart();

  $('#report_start_date').datetimepicker({
    format: 'DD/MM/YYYY HH:mm',
    locale: 'pt-br'
  });
  $('#report_end_date').datetimepicker({
    useCurrent: false,
    format: 'DD/MM/YYYY HH:mm',
    locale: 'pt-br'
  });
  $("#report_start_date").on("dp.change", function (e) {
      $('#report_end_date').data("DateTimePicker").minDate(e.date);
  });
  $("#report_end_date").on("dp.change", function (e) {
      $('#report_start_date').data("DateTimePicker").maxDate(e.date);
  });
});

function datepicker() {
  $(".datepicker_button").datetimepicker({ format: 'DD/MM/YYYY HH:mm' });

  $('input.format_value').priceFormat({
    prefix: 'R$ ',
    centsSeparator: ',',
    thousandsSeparator: '.'
  });
}

function fullcalendar() {
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

}

function pie_chart() {
  var placeholder = $("#pie_chart");
  var placeholder_url = placeholder.attr('data-url');
  var data = [];
  $.ajax({
    url: placeholder_url,
    dataType: 'json',
    data: {
      start_date: moment($('div.previous_date').attr('data-value')).format(),
      end_date: moment($('div.next_date').attr('data-value')).format(),
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
}

function bar_chart() {
  var placeholder = $("#bar_chart");
  var placeholder_url = placeholder.attr('data-url');
  var data_categories = [];
  var data_installments = [];
  var ticks = [];

  $.ajax({
    url: placeholder_url,
    dataType: 'json',
    data_categories: {
      start_date: moment($('div.previous_date').attr('data-value')).format(),
      end_date: moment($('div.next_date').attr('data-value')).format(),
    },
    success: function(doc) {
      var i = 0;
      $(doc).each(function() {
        var category_values = [];
        var installments_values = [];
        var ticks_categories = [];
        var ticks_installments = [];

        category_values.push(i);
        category_values.push($(this)[0].value);
        installments_values.push(i + 0.2);
        installments_values.push($(this)[0].installment_value);

        ticks_categories.push(i);
        ticks_categories.push($(this)[0].title);
        ticks_installments.push(i + 0.2);
        ticks_installments.push($(this)[0].format_total_value);

        data_categories.push(category_values);
        data_installments.push(installments_values);
        ticks.push(ticks_categories);
        ticks.push(ticks_installments);
        i += 1;
      });

      dataset = [
        {
          label: "Meta por categoria",
          data: data_categories,
          color: "#6487FF"
        },
        {
          label: "Total gasto no período",
          data: data_installments,
          color: "#49bf67"
        }
      ];

      options = {
        series: {
          bars: {
            show: true
          }
        },
        bars: {
          align: "center",
          barWidth: 0.2
        },
        xaxis: {
          axisLabel: "Categorias",
          axisLabelUseCanvas: true,
          axisLabelFontSizePixels: 12,
          axisLabelFontFamily: "Verdana, Arial",
          axisLabelPadding: 10,
          ticks: ticks
        },
        yaxis: {
          axisLabel: "Valor",
          axisLabelUseCanvas: true,
          axisLabelFontSizePixels: 12,
          axisLabelFontFamily: "Verdana, Arial",
          axisLabelPadding: 3,
          tickFormatter: function(v, axis) {
            return v;
          }
        },
        legend: {
          noColumns: 0,
          labelBoxBorderColor: "#000000",
          position: "nw"
        },
        grid: {
          hoverable: true,
          borderWidth: 2,
          backgroundColor: {
            colors: ["#ffffff", "#EDF5FF"]
          }
        }
      };

      $.plot(placeholder, dataset, options);

    }
  });

}