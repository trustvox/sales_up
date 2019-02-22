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
        grid: { hoverable: true, clickable: true, borderWidth: 0 },
        tooltip: true,
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

function generateGraphicPlot(reportPoints,contractPoints,dayText,
                             wdayText,isSales,lastDay) {
  var size = contractPoints.length;
  alert("eevveevev");
  var data = [
        set_graphic_parameters(reportPoints, list[0], 0, 0.1, true, 2),
        set_graphic_parameters(contractPoints, list[1], 6, 0.3, false),

        { data: [contractPoints[size-1]], color: "#23b7e5",
          points: { show: true, radius: 6, fillColor: '#23b7e5' } },

        { data: [[lastDay, 0]], points: { show: false } }
      ];
  var options = {
        colors: [ '#fad733','#23b7e5' ],
        series: { shadowSize: 2 },
        xaxes:[{ font: { color: '#ccc' }, ticks: dayText },
               { font: { color: '#ccc' }, ticks: wdayText }],
        yaxis:{ font: { color: '#ccc' } },
        grid: { hoverable: true, clickable: true, borderWidth: 0 },
        tooltip: true,
        tooltipOpts: { content: graphicSide(isSales),
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