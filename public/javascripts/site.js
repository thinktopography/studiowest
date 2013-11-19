Application = { }

$(document).ready(function(){
  $.localScroll(); 
  if($("div#map").size() > 0) {
	  var map = new GMap2(document.getElementById("map"));
	  var longitude = '-76.5066151320934';
	  var latitude = '42.4393513798714';
	  var point = new GLatLng(latitude, longitude, true);
	  map.setCenter(point, 16);
	  map.addOverlay(new GMarker(point));
	  map.addControl(new GSmallMapControl());
	  map.addControl(new GMapTypeControl());
  }
  Application.Navigation.Init();
  $("div#signup input.datepicker").datepicker({ dateFormat: 'yy-mm-dd' });
});