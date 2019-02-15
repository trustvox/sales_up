var colors = ["#fccaf9","#9ceaff","#b7ffc2","#d6ccc8", "#d1c1ee",
              "#fdd2ab","#c1d8ff","#ffc1c1","#dbdfe4", "#ffff99"]

function redirectToPipefy() {
  window.open("https://trustvox.pages.pipz.io/novo-cliente/");
}

function verifyMousePosition(event) {
  var x = event.clientX;
  if (x < 16 && x > -1)
    openNav();
  if (x > 200)
    closeNav();
}

function openNav() {
  document.getElementById("mySidenav").style.width = "200";
}

function closeNav() {
  document.getElementById("mySidenav").style.width = "0";
}

function verifyButtonData(id, first, second, third, forth) {
  var data_list = [document.getElementById(id+first).value,
                   document.getElementById(id+second).value,
                   document.getElementById(id+third).value];
  if (forth != '0')
    data_list.push(document.getElementById(id+forth).value);

  for (var i = 0; i < data_list.length; i++)
    if (data_list[i].trim() == "")
      return document.getElementById(id+'editContract').disabled = true;
  return document.getElementById(id+'editContract').disabled = false;
}

function englishLanguage() {
  return document.URL.split('/')[3] == "en";
}

function portugueseLanguage() {
  return document.URL.split('/')[3] == "pt";
}

function validateMyForm() {
  if (englishLanguage())
    return confirm("Do you want to perform this action?");
  else if(portugueseLanguage())
    return confirm("Deseja realizar esta ação?");
}

function obsVisibility(id, choice, which) {
  if (choice){
    if (which == 'edit'){
      document.getElementById(id+'edit').setAttribute("hidden", true);
      document.getElementById(id+'form_edit').removeAttribute("hidden");
    }
    else{
      document.getElementById(id+'create').setAttribute("hidden", true);
      document.getElementById(id+'form_create').removeAttribute("hidden");
    }

    document.getElementById(id+'l_observation').setAttribute("hidden", true);
    document.getElementById(id+'observation').removeAttribute("hidden");
  }
  else{
    if (which == 'edit'){
      document.getElementById(id+'edit').removeAttribute("hidden");
      document.getElementById(id+'form_edit').setAttribute("hidden", true);
    }
    else{
      document.getElementById(id+'create').removeAttribute("hidden");
      document.getElementById(id+'form_create').setAttribute("hidden", true);
    }

    document.getElementById(id+'l_observation').removeAttribute("hidden");
    document.getElementById(id+'observation').setAttribute("hidden", true);
  }
}

function fillObsData(id, which){
  var label = document.getElementById(id+'observation');
  var obs = document.getElementById(id+''+which);
  obs.value = label.value
}

function fillUserData(id, permission) {
  var param_priority = null;
  var query_priority = null;
  var param_type = null;
  var query_type = null;

  param_priority = document.getElementById(id+'permission');
  query_priority = document.getElementById(id+'permission'+id);

  param_type = document.getElementById(id+'area');
  query_type = document.getElementById(id+'area'+id);

  query_priority.value = param_priority.value;
  query_type.value = param_type.value;
}

function fillData(id, first, second, third, forth, fifth, sixth) {
  var param_list = [document.getElementById(id+first),
                    document.getElementById(id+second),
                    document.getElementById(id+third),
                    document.getElementById(id+forth),
                    document.getElementById(id+fifth),
                    document.getElementById(id+sixth)];

  var query_list = [document.getElementById(id+first+id),
                    document.getElementById(id+second+id),
                    document.getElementById(id+third+id),
                    document.getElementById(id+forth+id),
                    document.getElementById(id+fifth+id),
                    document.getElementById(id+sixth+id)];

  for (var i = 0; i < query_list.length; i++)
    if (param_list[i] != null)
      query_list[i].value = param_list[i].value
}

function redirectPage(id) {
  document.getElementById(id).submit();
}

function sendData(formName, input, quantity) {
  if (input == 0){
    var year = document.getElementById("monthBox");
    var text = year.value.split('/');

    document.getElementById("monthSelected").value = text[0];
    year[year.selectedIndex].value = text[1];
  }
  else if (input == 1){
    var years = document.getElementById("report_years");

    for (var i = 0; i < quantity; i++) {
      var year = document.getElementsByName(i + "_year")[0];
      years.value += year.options[year.selectedIndex].value + "/";
    }
  }
  document.getElementById(formName).submit();
}

function cleanDataSpreadsheet(current_year) {
  document.getElementById('report_name_n').value = "";
  document.getElementById('goal_n').value = "";
  document.getElementById('month_n').selectedIndex = 0
  document.getElementById('year_n').value = current_year;
  document.getElementById('obs_n').value = "";
  document.getElementById('scheduled_raise_n').value = "";
}

function cleanDataContract(id) {
  document.getElementById('contract_store_name').value = "";
  document.getElementById('contract_value').value = "";
  document.getElementById('contract_report_id').selectedIndex = 0
  document.getElementById('username'+id).checked = true;
}

function cleanDataMeeting(date_list, id) {
  document.getElementById('meeting_day').value = date_list[2];
  document.getElementById('meeting_report_id').selectedIndex = 0
  document.getElementById('username'+id).checked = true;
  document.getElementById(id+'username'+id).checked = true;

  var dateID = 'meeting_scheduled_for_'
  for (var i = 0; i < 5; i++)
    document.getElementById(dateID+(i+1)+'i').value = date_list[i];
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

function setDateTimeInInput(id, first, second, third, forth) {
  var dateData = document.getElementById(id+'scheduled_for_date').value;
  var timeData = document.getElementById(id+'scheduled_for_time').value;
  document.getElementById(id+'scheduled_for').value = dateData + ' ' + timeData;

  verifyButtonData(id, first, second, third, forth);
}

function setDateTime(dateID, timeID, dateTimeID, date, time) {
  document.getElementById(dateID).value = date;
  document.getElementById(timeID).value = time;
  document.getElementById(dateTimeID).value = date + ' ' + time;
}

function highLightContract(store_names, salesman_names, storeId, salesmanId) {
  document.getElementById(storeId).innerHTML =
    setTextColor(store_names.split('; '));
  document.getElementById(salesmanId).innerHTML =
    setTextColor(salesman_names.split('; '));
}

function highLightMeeting(store_name, scheduled_for, salesman_name, hunter_name,
                          storeId, scheduledId, salesmanId, hunterId) {
  document.getElementById(storeId).innerHTML =
    setTextColor(store_name.split('; '));
  document.getElementById(scheduledId).innerHTML =
    setTextColor(scheduled_for.split('; '));
  document.getElementById(salesmanId).innerHTML =
    setTextColor(salesman_name.split('; '));
  document.getElementById(hunterId).innerHTML =
    setTextColor(hunter_name.split('; '));
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

function graphicTranslation() {
  if (englishLanguage())
    return ["Goal", "Reached", "Day", "$", "Meeting(s)", "Month"];
  else if(portugueseLanguage())
    return ["Meta", "Alcançado", "Dia", "R$", "Reunião(ões)", "Mês"];
}

function graphicSide(isSales) {
  list = graphicTranslation();
  if (isSales)
    return list[2]+' %x.0: ' + list[3] + '%y.2';
  else
    return list[2]+' %x.0: %y ' + list[4];
}

function graphicSideOverview(isSales) {
  list = graphicTranslation();
  if (isSales)
    return list[3] + '%y.2';
  else
    return '%y ' + list[4];
}

function generateOverviewPlot(goalPoints,sumPoints,monthText,isSales) {
  var subt = graphicSideOverview(isSales);

  var data = [
        { data: goalPoints, label: list[0], points: { show: true },
          lines: { show: true, fill: true,
          fillColor: { colors: [{ opacity: 0.1 }, { opacity: 0.1}] } } },
        { data: sumPoints, label: list[1], points: { show: true, radius: 6 },
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
  var subt = graphicSide(isSales);

  var data = [
        { data: reportPoints, xaxis: 2, label: list[0], points: { show: true },
          lines: { show: true, fill: true,
          fillColor: { colors: [{ opacity: 0.1 }, { opacity: 0.1}] } } },
        { data: contractPoints, label: list[1],
          points: { show: true, radius: 6 },
          lines: { show: true, fill: true, fillColor: {
                   colors: [{ opacity: 0.3 }, { opacity: 0.3}] } } },
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
        tooltipOpts: { content: subt,
                       defaultTheme: false, shifts: { x: 0, y: 20 } }
  };
  $.plot($("#placeholderG"), data, options);
}

function generateRecordPlot(salesPoints, names, dayText, wdayText, isSales) {
  var subt = graphicSideOverview(isSales);
  var data = [];
  var option_color = [];
  var i = 0;

  for (i = 0; i < salesPoints.length-1; i++) {
    data.push({ data: salesPoints[i], xaxis: 1, label: names[i],
          points: { show: true, radius: 6 },
          lines: { show: true, fill: true, fillColor: {
                   colors: [{ opacity: 0.3 }, { opacity: 0.3}] } } });
    option_color.push(colors[i]);
  }

  data.push({ data: salesPoints[i], xaxis: 2, label: names[i],
          points: { show: true, radius: 6 },
          lines: { show: true, fill: true, fillColor: {
                   colors: [{ opacity: 0.3 }, { opacity: 0.3}] } } });
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

function stringToMonth(text) {
  if (portugueseLanguage()){
    switch(text) {
      case "Jan": return "January";
      case "Fev": return "February";
      case "Mar": return "March";
      case "Abr": return "April";
      case "Mai": return "May";
      case "Jun": return "June";
      case "Jul": return "July";
      case "Ago": return "August";
      case "Set": return "September";
      case "Out": return "October";
      case "Nov": return "November";
      default: return "December";
    }
  }
  switch(text) {
    case "Jan": return "January";
    case "Feb": return "February";
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
