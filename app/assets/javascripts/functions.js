function validateMyForm() {
	var answer = confirm("Deseja realizar esta ação?");
	return answer;
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
  for (var i = 0; i < query_list.length; i++) {
    query_list[i].value = param_list[i].value
  }
}

function sendData(formName, input) {
  if (input == 0)
  {
    var month = document.getElementById("monthSelected");
    var year = document.getElementById("monthBox");
    var x = document.getElementById("monthBox").selectedIndex;
    var text = year.value.split('/');
    month.value = text[0];
    year[x].value = text[1];
  }
  document.getElementById(formName).submit();
}

function cleanDataSpreadsheet() {
  var report_name = document.getElementById('report_name_n');
  var goal = document.getElementById('goal_n');
  var month = document.getElementById('month_n');
  var year = document.getElementById('year_n');

  report_name.value = "";
  goal.value = "";
  month.selectedIndex = 0
  year.value = "";
}

function cleanDataContract() {
  var store_name = document.getElementById('contract_store_name');
  var contract_value = document.getElementById('contract_value');
  var report = document.getElementById('contract_report');
  var day = document.getElementById('contract_day');
  var username = document.getElementById('contract_username');

  store_name.value = "";
  contract_value.value = "";
  report.selectedIndex = 0
  day.value = "";
  username.checked = true;
}

function fillUsername(idList) {
  var user_id = document.getElementById('user_id');
  for (var i = 0; i < idList.length; i++) {
    if (document.getElementById(idList[i]).checked) {
      user_id.value = document.getElementById(idList[i]).value;
      break;
    }
  }
}
