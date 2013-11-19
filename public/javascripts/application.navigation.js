Application.Navigation = { }

Application.Navigation.Init = function() {
  $("div.presence span").live("click", Application.Navigation.Open);
  $("div.presence").live("mouseleave", Application.Navigation.Close);
}

Application.Navigation.Open = function() {
  $('div.presence').addClass('active');
}

Application.Navigation.Close = function() {
  $('div.presence').removeClass('active');
}