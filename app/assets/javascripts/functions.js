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

function verifyButtonData() {
  id = arguments[0];

  for (var i = 1; i < arguments.length; i++)
    if (document.getElementById(id+arguments[i]).value.trim() == "")
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
  l_obs = document.getElementById(id+'l_observation');
  obs = document.getElementById(id+'observation');
  which_id = document.getElementById(id+which);
  form_which = document.getElementById(id+'form_'+which);

  if (choice)
    showObservation(l_obs, obs, which_id, form_which);
  else
    hideObservation(l_obs, obs, which_id, form_which);
}

function showObservation(l_obs, obs, which, form_which){
  which.setAttribute("hidden", true);
  form_which.removeAttribute("hidden");

  l_obs.setAttribute("hidden", true);
  obs.removeAttribute("hidden");
}

function hideObservation(l_obs, obs, which, form_which){
  which.removeAttribute("hidden");
  form_which.setAttribute("hidden", true);

  l_obs.removeAttribute("hidden");
  obs.setAttribute("hidden", true);
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

function setDateTimeInInput() {
  id = arguments[0];

  var dateData = document.getElementById(id+'scheduled_for_date').value;
  var timeData = document.getElementById(id+'scheduled_for_time').value;
  document.getElementById(id+'scheduled_for').value = dateData + ' ' + timeData;

  verifyButtonData(arguments);
}

function setDateTime() {
  document.getElementById(arguments[0]).value = arguments[3];
  document.getElementById(arguments[1]).value = arguments[4];
  document.getElementById(arguments[2]).value = 
    arguments[3] + ' ' + arguments[4];
}

function highLightContract(store_names, salesman_names, storeId, salesmanId) {
  document.getElementById(storeId).innerHTML =
    setTextColor(store_names.split('; '));
  document.getElementById(salesmanId).innerHTML =
    setTextColor(salesman_names.split('; '));
}

function highLightMeeting() {
  for (var i = 0; i < 4; i++)
    document.getElementById(arguments[i+4]).innerHTML =
      setTextColor(arguments[i].split('; '));
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
