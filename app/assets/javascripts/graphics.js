function generateOverviewPlot(goalPoints,sumPoints,monthText,isSales) {
  var subt = graphicSideOverview(isSales);

  var data = [ set_overview_parameters(goalPoints, list[0], 0, 0.1),
               set_overview_parameters(sumPoints, list[1], 6, 0.3)
      ];
  var options = {
        colors: [ '#fad733','#23b7e5' ],
        series: { shadowSize: 2 },
        xaxis:{ font: { color: '#ccc' }, ticks: monthText },
        yaxis:{ font: { color: '#ccc' } },
        grid:{ hoverable: true, clickable: true, borderWidth: 0},tooltip: true,
        tooltipOpts: { content: subt,  defaultTheme: false,
                        shifts: { x: 0, y: 20 } }
  };

  $.plot($("#placeholderO"), data, options);
  $("#placeholderO").bind("plotclick", function (event, pos, item) {
    if (item != null) {
      var data = [stringToMonth(monthText[item.dataIndex][1].substring(0,3)),
                  "20"+monthText[item.dataIndex][1].substring(4,7)];
      var month = document.getElementById("monthSearch");
      var year = document.getElementById("yearSearch");

      month.value = data[0];
      year.value = data[1];

      document.getElementById("formSearch").submit();
    }
  });
}

function generateOverviewRecordPlot(salesPoints,names,monthText,simbol) {
  var data = [];
  var option_color = [];

  for (var i = 0; i < salesPoints.length; i++) {
    data.push({ data: salesPoints[i], label: names[i],
          points: { show: true, radius: 6 },
          lines: { show: true, fill: true, fillColor: {
                   colors: [{ opacity: 0.3 }, { opacity: 0.3}] } } });
    option_color.push(colors[i]);
  }
  var options = {
        colors: option_color,
        series: { shadowSize: 2 },
        xaxis:{ font: { color: '#ccc' }, ticks: monthText },
        yaxis:{ font: { color: '#ccc' } },
        grid: { hoverable: true, clickable: true, borderWidth: 0 },
        tooltip: true,
        tooltipOpts: { content: simbol,  defaultTheme: false,
                        shifts: { x: 0, y: 20 } }

  };
  $.plot($("#placeholderOR"), data, options);
}

function generateGraphicPlot() {
  var monthData = arguments[7];
  var yearData = arguments[8];
  
  var size = arguments[1].length;
  var data = [
        set_graphic_parameters(arguments[0], "Goal", 0, 0.1, 2),
        set_graphic_parameters(arguments[1], "Reached", 6, 0.3, 0),
        set_graphic_parameters(arguments[6], "Forecast", 6, 0.3, 0),

        { data: [arguments[1][size-1]], color: "#23b7e5",
          points: { show: true, radius: 6, fillColor: '#23b7e5' } },

        { data: [[arguments[5], 0]], points: { show: false } }
      ];
  var options = {
        colors: [ '#fad733','#23b7e5','#6254b2' ],
        series: { shadowSize: 2 },
        xaxes:[{ font: { color: '#ccc' }, ticks: arguments[2] },
               { font: { color: '#ccc' }, ticks: arguments[3] }],
        yaxis:{ font: { color: '#ccc' } },
        grid: { hoverable: true, clickable: true, borderWidth: 0 },
        tooltip: true,
        tooltipOpts: { content: graphicSide(arguments[4]),
                       defaultTheme: false, shifts: { x: 0, y: 20 } }
  };
  $.plot($("#placeholderG"), data, options);
  $("#placeholderG").bind("plotclick", function (event, pos, item) {
    if (item != null && item.dataIndex == 1) {
      var month = document.getElementById("monthSearch");
      var year = document.getElementById("yearSearch");

      month.value = monthData;
      year.value = yearData;

      document.getElementById("formSearch").submit();
    }
  });
}

function generateForecastGraphicPlot() {
  var size = arguments[1].length;
  var data = [
        set_graphic_parameters(arguments[0], "Goal", 0, 0.1, 2),
        set_graphic_parameters(arguments[1], "Reached", 6, 0.3, 0),

        { data: [[arguments[5], 0]], points: { show: false } }
      ];
  var options = {
        colors: [ '#fad733','#6254b2' ],
        series: { shadowSize: 2 },
        xaxes:[{ font: { color: '#ccc' }, ticks: arguments[2] },
               { font: { color: '#ccc' }, ticks: arguments[3] }],
        yaxis:{ font: { color: '#ccc' } },
        grid: { hoverable: true, clickable: true, borderWidth: 0 },
        tooltip: true,
        tooltipOpts: { content: graphicSide(arguments[4]),
                       defaultTheme: false, shifts: { x: 0, y: 20 } }
  };
  $.plot($("#placeholderG"), data, options);
}

function generateRecordPlot(salesPoints, names, dayText, wdayText) {
  var subt = graphicSideOverview(names.length == 4);
  var data = [];
  var option_color = [];
  var i = 0;

  for (; i < salesPoints.length-1; i++) {
    data.push(add_point_data(salesPoints[i], names[i], 1));
    option_color.push(colors[i]);
  }

  data.push(add_point_data(salesPoints[i], names[i], 2));
  option_color.push(colors[i]);

  var options = {
          colors: option_color,
          series: { shadowSize: 2 },
          xaxes:[{ font: { color: '#ccc' }, ticks: dayText },
                 { font: { color: '#ccc' }, ticks: wdayText }],
          yaxis:{ font: { color: '#ccc' } },
          grid: { hoverable: true, clickable: true, borderWidth: 0 },
          tooltip: true,
          tooltipOpts: { content: list[2]+' %x.0: ' + subt,
                         defaultTheme: false, shifts: { x: 0, y: 20 } }
  };
  $.plot($("#placeholderR"), data, options);
}