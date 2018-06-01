var colors = ["#ffff99","#fccaf9","#9ceaff","#d1c1ee","#b7ffc2","#d6ccc8",
              "#fdd2ab","#c1d8ff","#ffc1c1","#dbdfe4"]


function validateMyForm() {
	return confirm("Deseja realizar esta ação?");
}

function reportVisibility(id, choice) {
  if (choice){
    document.getElementById(id+'report_name').removeAttribute("hidden");
    document.getElementById(id+'goal').removeAttribute("hidden");
    document.getElementById(id+'month').removeAttribute("hidden");
    document.getElementById(id+'year').removeAttribute("hidden");

    document.getElementById(id+'l_report_name').setAttribute("hidden", true);
    document.getElementById(id+'l_goal').setAttribute("hidden", true);
    document.getElementById(id+'l_month_year').setAttribute("hidden", true);

    document.getElementById(id+'divR1').setAttribute("hidden", true);
    document.getElementById(id+'divR2').removeAttribute("hidden");
  }
  else{
    document.getElementById(id+'report_name').setAttribute("hidden", true);
    document.getElementById(id+'goal').setAttribute("hidden", true);
    document.getElementById(id+'month').setAttribute("hidden", true);
    document.getElementById(id+'year').setAttribute("hidden", true);

    document.getElementById(id+'l_report_name').removeAttribute("hidden");
    document.getElementById(id+'l_goal').removeAttribute("hidden");
    document.getElementById(id+'l_month_year').removeAttribute("hidden");

    document.getElementById(id+'divR1').removeAttribute("hidden");
    document.getElementById(id+'divR2').setAttribute("hidden", true);
  }
}

function fillData(id, first, second, third, forth) {
  var param_list = [document.getElementById(id+first),
                    document.getElementById(id+second),
                    document.getElementById(id+third),
                    document.getElementById(id+forth)];
  var query_list = [document.getElementById(id+first+id),
                    document.getElementById(id+second+id),
                    document.getElementById(id+third+id),
                    document.getElementById(id+forth+id)];
  for (var i = 0; i < query_list.length; i++)
    query_list[i].value = param_list[i].value
}

function sendData(formName, input) {
  if (input == 0)
  {
    var year = document.getElementById("monthBox");
    var text = year.value.split('/');
    document.getElementById("monthSelected").value = text[0];
    year[year.selectedIndex].value = text[1];
  }
  document.getElementById(formName).submit();
}

function cleanDataSpreadsheet(current_year) {
  document.getElementById('report_name_n').value = "";
  document.getElementById('goal_n').value = "";
  document.getElementById('month_n').selectedIndex = 0
  document.getElementById('year_n').value = current_year;
}

function cleanDataContract() {
  document.getElementById('contract_store_name').value = "";
  document.getElementById('contract_value').value = "";
  document.getElementById('contract_report').selectedIndex = 0
  document.getElementById('contract_day').value = "";
  document.getElementById('contract_username').checked = true;
}

function fillUsername(idList) {
  for (var i = 0; i < idList.length; i++) {
    if (document.getElementById(idList[i]).checked) {
      document.getElementById('user_id').value =
        document.getElementById(idList[i]).value;
      break;
    }
  }
}

function highLight(store_names, salesman_names, storeId, salesmanId) {
  document.getElementById(storeId).innerHTML =
    setTextColor(store_names.split('; '));
  document.getElementById(salesmanId).innerHTML =
    setTextColor(salesman_names.split('; '));
}

function setTextColor(text) {
  text.splice(-1,1);
  var colorIndex = 0;
  var result = "";
  for (var i = 0; i < text.length; i++) {
    result += "<strong style='background-color: "+colors[colorIndex]+"'>"+
              text[i].substring(2, text[i].length).fontcolor("black")+
              "</strong> - ";
    if (colorIndex < colors.length)
      colorIndex++;
    else
      colorIndex = 0;
  }
  return result.substring(0,result.length-3);
}

function generateOverviewPlot(goalPoints,sumPoints,monthText) {
  var data = [
        { data: goalPoints, label: 'Goal', points: { show: true },
          lines: { show: true, fill: true,
          fillColor: { colors: [{ opacity: 0.1 }, { opacity: 0.1}] } } },
        { data: sumPoints, label: 'Reached', points: { show: true, radius: 6 },
          lines: { show: true, fill: true,
          fillColor: { colors: [{ opacity: 0.3 }, { opacity: 0.3}] } } }
      ];
  var options = {
        colors: [ '#fad733','#23b7e5' ],
        series: { shadowSize: 2 },
        xaxis:{ font: { color: '#ccc' }, ticks: monthText },
        yaxis:{ font: { color: '#ccc' } },
        grid: { hoverable: true, clickable: true, borderWidth: 0 },
        tooltip: true,
        tooltipOpts: { content: 'R$%y.2',  defaultTheme: false,
                        shifts: { x: 0, y: 20 } }

  };
  $.plot($("#placeholderO"), data, options);
  $("#placeholderO").bind("plotclick", function (event, pos, item) {
    if (item != null) {
      var data = [stringToMonth(monthText[item.dataIndex][1].substring(0,3)),
                  "20"+monthText[item.dataIndex][1].substring(4,7)];
      var month = document.getElementById("monthSearch");
      var year = document.getElementById("yearSearch");

      alert(data);
      alert(month);
      alert(year);

      month.value = data[0];
      year.value = data[1];

      document.getElementById("formSearch").submit();
    }
});
}

function generateGraphicPlot(reportPoints,contractPoints,dayText,month,year) {
  var data = [
        { data: reportPoints, label: 'Goal', points: { show: true },
          lines: { show: true, fill: true,
          fillColor: { colors: [{ opacity: 0.1 }, { opacity: 0.1}] } } },
        { data: contractPoints, label: 'Reached',
          points: { show: true, radius: 6 },
          lines: { show: true, fill: true, fillColor: {
                   colors: [{ opacity: 0.3 }, { opacity: 0.3}] } } }
      ];
  var options = {
        colors: [ '#fad733','#23b7e5' ],
        series: { shadowSize: 2 },
        xaxis:{ font: { color: '#ccc' }, ticks: dayText },
        yaxis:{ font: { color: '#ccc' } },
        grid: { hoverable: true, clickable: true, borderWidth: 0 },
        tooltip: true,
        tooltipOpts: { content: 'Day %x.0: R$%y.2',
                       defaultTheme: false, shifts: { x: 0, y: 20 } }
  };
  $.plot($("#placeholderG"), data, options);
  $("#placeholderG").bind("plotclick", function (event, pos, item) {
    if (item != null)
      window.location.replace("/monthly_sales?report[month]=" +
                              month + "&report[year]=" + year);
});
}

function stringToMonth(text) {
  switch(text) {
    case "Jan": return "January";
    case "Feb": return "Febuary";
    case "Mar": return "March";
    case "Apr": return "April";
    case "May": return "May";
    case "Jun": return "June";
    case "Jul": return "July";
    case "Aug": return "August";
    case "Sep": return "September";
    case "Oct": return "October";
    case "Nov": return "November";
    default: return "December";
  }
}
