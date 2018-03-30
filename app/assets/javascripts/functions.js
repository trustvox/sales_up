function validateMyForm() {
	var answer = confirm("Deseja realizar esta ação?");
	return answer;
}
function reportVisibility(id, choice) {
  if (choice){
    document.getElementById(id+'report_name').style.visibility = "visible";
    document.getElementById(id+'goal').style.visibility = "visible";
    document.getElementById(id+'month').style.visibility = "visible";
    document.getElementById(id+'year').style.visibility = "visible";

    document.getElementById(id+'l_report_name').style.visibility = "hidden";
    document.getElementById(id+'l_goal').style.visibility = "hidden";
    document.getElementById(id+'l_month_year').style.visibility = "hidden";

    document.getElementById(id+'divR1').style.visibility = "hidden";
    document.getElementById(id+'divR2').style.visibility = "visible";
  }
  else{
    document.getElementById(id+'report_name').style.visibility = "hidden";
    document.getElementById(id+'goal').style.visibility = "hidden";
    document.getElementById(id+'month').style.visibility = "hidden";
    document.getElementById(id+'year').style.visibility = "hidden";

    document.getElementById(id+'l_report_name').style.visibility = "visible";
    document.getElementById(id+'l_goal').style.visibility = "visible";
    document.getElementById(id+'l_month_year').style.visibility = "visible";

    document.getElementById(id+'divR1').style.visibility = "visible";
    document.getElementById(id+'divR2').style.visibility = "hidden";
  }
}

function fillReportData(id) {
  var submit = document.getElementById(id+'submitR');
  var report_name = document.getElementById(id+'report_name');
  var goal = document.getElementById(id+'goal');
  var month = document.getElementById(id+'month');
  var year = document.getElementById(id+'year');

  submit.value = 'id:' + id + '/-/' + report_name.value + '/-/' + goal.value + '/-/' + month.value + '/-/' + year.value
}

function contractVisibility(id, choice) {
  if (choice){
    document.getElementById(id+'day').style.visibility = "visible";
    document.getElementById(id+'store_name').style.visibility = "visible";
    document.getElementById(id+'value').style.visibility = "visible";
    document.getElementById(id+'username').style.visibility = "visible";

    document.getElementById(id+'l_day').style.visibility = "hidden";
    document.getElementById(id+'l_store_name').style.visibility = "hidden";
    document.getElementById(id+'l_value').style.visibility = "hidden";
    document.getElementById(id+'l_username').style.visibility = "hidden";

    document.getElementById(id+'divC1').style.visibility = "hidden";
    document.getElementById(id+'divC2').style.visibility = "visible";
  }
  else{
    document.getElementById(id+'day').style.visibility = "hidden";
    document.getElementById(id+'store_name').style.visibility = "hidden";
    document.getElementById(id+'value').style.visibility = "hidden";
    document.getElementById(id+'username').style.visibility = "hidden";

    document.getElementById(id+'l_day').style.visibility = "visible";
    document.getElementById(id+'l_store_name').style.visibility = "visible";
    document.getElementById(id+'l_value').style.visibility = "visible";
    document.getElementById(id+'l_username').style.visibility = "visible";

    document.getElementById(id+'divC1').style.visibility = "visible";
    document.getElementById(id+'divC2').style.visibility = "hidden";
  }
}

function fillContractData(idCont, idRep) {
  var submit = document.getElementById(idCont+'submitC');
  var day = document.getElementById(idCont+'day');
  var store_name = document.getElementById(idCont+'store_name');
  var value = document.getElementById(idCont+'value');
  var username = document.getElementById(idCont+'username');

  submit.value = 'id:' + idCont + '/-/' + day.value + '/-/' + store_name.value + '/-/' + value.value + '/-/' + username.value + '/-/' + idRep
}
