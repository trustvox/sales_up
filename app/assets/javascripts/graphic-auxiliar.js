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
  
  return list[2]+' %x.0: %y ' + list[4];
}

function graphicSideOverview(isSales) {
  list = graphicTranslation();
  if (isSales)
    return list[3] + '%y.2';
  
  return '%y ' + list[4];
}

function set_overview_parameters(goalPoints,list,rad,opac) {
  return { data: goalPoints, label: list, points: { show: true, radius: rad },
           lines: { show: true, fill: true,
           fillColor: { colors: [{ opacity: opac }, { opacity: opac }] } } }
}

function add_point_data(point, name, xpoint) {
  return { data: point, xaxis: xpoint, label: name,
          points: { show: true, radius: 6 },
          lines: { show: true, fill: true, fillColor: {
                   colors: [{ opacity: 0.3 }, { opacity: 0.3}] } } }
}

function stringToMonth(text) {
  months = fetch_months();
  full_month = ["January", "February", "March", "April", "May", "June", "July",
                "August", "September", "October", "November", "December"];

  for (var i = 0; i < months.length; i++) 
    if (months[i] == text)
      return full_month[i];
}

function fetch_months() {
  if (portugueseLanguage())
    return ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun", 
            "Jul", "Ago", "Set", "Out", "Nov"];
  
  return ["Jan", "Feb", "Mar", "Apr", "May", "Jun", 
          "Jul", "Aug", "Sep", "Oct", "Nov"];
}

function set_graphic_parameters() {
  axis = {}

  if (arguments[4] != undefined)
    axis = { xaxis: arguments[4] }

  return { data: arguments[0], axis, label: arguments[1], 
            points: { show: true, radius: arguments[2] }, 
            lines: { show: true, fill: true, fillColor: { colors: 
              [{ opacity: arguments[3] }, { opacity: arguments[3]}] } } } 
}