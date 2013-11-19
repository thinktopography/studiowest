Application = { }

Application.Init = function() {
  Application.Schedule.Init();
  Application.Navigation.Init();
}

$(document).ready(function(){
  Application.Init();
});