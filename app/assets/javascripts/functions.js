function validateMyForm(isContract, index) {
	var answer = confirm("Deseja realizar esta ação?");
  if (isContract.split('/')[0] == 'contract'){
    fetchData(isContract.split('/')[1]);
  }
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
    document.getElementById(id+'day').removeAttribute("hidden");
    document.getElementById(id+'store_name').removeAttribute("hidden");
    document.getElementById(id+'value').removeAttribute("hidden");
    document.getElementById(id+'username').removeAttribute("hidden");

    document.getElementById(id+'l_day').setAttribute("hidden", true);
    document.getElementById(id+'l_store_name').setAttribute("hidden", true);
    document.getElementById(id+'l_value').setAttribute("hidden", true);
    document.getElementById(id+'l_username').setAttribute("hidden", true);

    document.getElementById(id+'divC1').setAttribute("hidden", true);
    document.getElementById(id+'divC2').removeAttribute("hidden");
  }
  else{
    document.getElementById(id+'day').setAttribute("hidden", true);
    document.getElementById(id+'store_name').setAttribute("hidden", true);
    document.getElementById(id+'value').setAttribute("hidden", true);
    document.getElementById(id+'username').setAttribute("hidden", true);

    document.getElementById(id+'l_day').removeAttribute("hidden");
    document.getElementById(id+'l_store_name').removeAttribute("hidden");
    document.getElementById(id+'l_value').removeAttribute("hidden");
    document.getElementById(id+'l_username').removeAttribute("hidden");

    document.getElementById(id+'divC1').removeAttribute("hidden");
    document.getElementById(id+'divC2').setAttribute("hidden", true);
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

function sendData(formName) {
  document.getElementById(formName).submit();
}

function cleanDataSpreadsheet() {
  var report_name = document.getElementById('report_name');
  var goal = document.getElementById('goal');
  var month = document.getElementById('month');
  var year = document.getElementById('year');

  report_name.value = "";
  goal.value = "";
  month.selectedIndex = 0
  year.value = "";
}

function cleanDataContract() {
  var store_name = document.getElementById('store_name');
  var contract_value = document.getElementById('value');
  var report = document.getElementById('report');
  var day = document.getElementById('day');
  var username = document.getElementById('username');

  store_name.value = "";
  contract_value.value = "";
  report.selectedIndex = 0
  day.value = "";
  username.checked = true;
}

function fetchData(index) {
  var data = document.getElementById(index+'contract_data');
  data.value += "/-/" + document.getElementById(index+'dayAlt').value + "/-/" + document.getElementById(index+'store_nameAlt').value + "/-/" +
          document.getElementById(index+'valueAlt').value + "/-/" + document.getElementById(index+'usernameAlt').value;
}

function verifyUsername(username_list, current_username) {
  var list = [];
  for (var i = 0; i < username_list.length; i++) {
    if (username_list[i] != current_username){
      list[i] = username_list[i];
    }
    else{
      list.unshift(username_list[i]);
    }
  }
  return list;
}

function editContract(day, usernames){
  var contracts = document.getElementById(day+'edit').value.split('/-/')
  var table = $('#editTableContract');
  var inputs = ""
  var ids = ""

  for (var i = 0; i < contracts.length; i++) {
    var contracts_data = contracts[i].split('/');
    var allUserNames = verifyUsername(usernames.split('/-/'), contracts_data[3]);
    var index = i.toString();

    inputs += "<tr>"+
                  "<td class='v-middle'>"+
                    "<input style='width: 55px;' type='number' value='" + day + "' id='"+index+"dayAlt'>"+
                  "</td>"+
                  "<td class='v-middle'>"+
                    "<input style='width: 265px;' type='text' value='" + contracts_data[1] + "' id='"+index+"store_nameAlt'>"+
                  "</td>"+
                  "<td class='v-middle'>"+
                    "<input style='width: 100px;' type='decimal' value='" + contracts_data[2] + "' id='"+index+"valueAlt'>"+
                  "</td>"+
                  "<td class='v-middle'>"+
                    "<select id='"+index+"usernameAlt'>"+
                      "<option value='" + allUserNames[0] + "'>" + allUserNames[0] + "</option>"+
                      "<option value='" + allUserNames[1] + "'>" + allUserNames[1] + "</option>"+
                      "<option value='" + allUserNames[2] + "'>" + allUserNames[2] + "</option>"+
                      "<option value='" + allUserNames[3] + "'>" + allUserNames[3] + "</option>"+
                      "<option value='" + allUserNames[4] + "'>" + allUserNames[4] + "</option>"+
                    "</select>"+
                  "</td>"+
                "<td>"+
                  "<div class='form-inline'>"+
                    "<form id='alter_contract' class='form-group' method='post' action='/alter_contract_data' onsubmit=if(!validateMyForm('contract/"+index+"')){event.preventDefault();}>"+
                      "<button class='btn btn-success' id='" + index + "contract_data' name='contract_data' type='submit' value='" + contracts_data[0] + "'> Save</button>"+
                    "</form>"+
                    "<form class='form-group' method='post' action='/delete_contract_data' onsubmit='if(!validateMyForm()){event.preventDefault();}'>"+
                      "<button class='btn btn-danger m-l' name='delete' value='" + contracts_data[0] + "'> Delete</button>"+
                    "</form>"+
                  "</div>"
                "</td>"+
              "</tr>"
    ids += contracts_data[0] + "/-/"
  }
  table[0].innerHTML = inputs;
  document.getElementById('btnSubmit').value = ids
}
