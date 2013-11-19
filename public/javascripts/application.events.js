Application.Schedule = { }

Application.Schedule.Init = function() {
  $("div.reservation").live("click", Application.Schedule.Open);
  $("a.previous, a.today, a.next").live("click", Application.Schedule.Page)
  $("div.schedule select.resource").live("change", Application.Schedule.Resource);
  $("div.schedule select.member").live("change", Application.Schedule.Member);
  $('div.tabs li a').live('click', Application.Schedule.Tab);
  $('div.schedule input.datepicker').live('click', Application.Schedule.Date);
  $("div.reservation-form input.datepicker").datepicker({ dateFormat: 'yy-mm-dd'});
  $("div.reservation-form form").live("submit", Application.Schedule.Reserve);
  $("div.slot").live("mousedown", Application.Schedule.Start);
  $("div.column").live("mousemove", Application.Schedule.Continue);
  $("div.column").live("mouseup", Application.Schedule.Stop);
  $("div.column").live("mouseleave", Application.Schedule.Stop);
  $("a.cancel").live("click", Application.Schedule.Cancel);
  $("span.reset").live("click", Application.Schedule.Reset);
  $("span.floorplan-show").live("click", Application.Schedule.ShowFloorplan);
  $("div.floorplan").live("click", Application.Schedule.HideFloorplan);
  $("div.schedule input.datepicker").datepicker({ dateFormat: 'yy-mm-dd', onSelect: Application.Schedule.Date });
}

Application.Schedule.ShowFloorplan = function() {
  $('div.floorplan').fadeIn();
  $('div.floorplan-window').fadeIn();
}

Application.Schedule.HideFloorplan = function() {
  $('div.floorplan').fadeOut();
  $('div.floorplan-window').fadeOut();
}

Application.Schedule.Start = function(e) {
  var unit = $(this).data('unit');
  var top = 6 * unit + unit;
  Application.Schedule.Begin = $(this);
  Application.Schedule.First = unit;
  Application.Schedule.Top = e.pageY;
  $("div#new-reservation").remove();
  $(this).closest('div.column-body').append('<div id="new-reservation" class="reservation new" style="height:6px; top:'+top+'px;">&nbsp;</div>');
  Application.Schedule.Continue(e);
  return false;
}

Application.Schedule.Continue = function(e) {
  if(Application.Schedule.Begin != null) {
    Application.Schedule.Bottom = e.pageY
    var height = (Application.Schedule.Bottom - Application.Schedule.Top)
    var units = parseInt((height + 1) / 7);
    var adjusted_height = ((units + 1) * 7) - 1;
    Application.Schedule.Last = Application.Schedule.First + units
    $('div#new-reservation').css('height', adjusted_height);
    Application.Schedule.Update();
  }
  return false;
}

Application.Schedule.Clear = function() {
  Application.Schedule.Begin = null;
  Application.Schedule.First = null;
  Application.Schedule.Last = null;
  Application.Schedule.Top = null;
  Application.Schedule.Bottom = null;
}

Application.Schedule.Stop = function() {
  if(Application.Schedule.First != null) {
    Application.Schedule.Update();
    Application.Schedule.Clear();
  }
  return false;
}

Application.Schedule.Abort = function() {
  if(Application.Schedule.First != null) {
    $("div#new-reservation").remove();
    Application.Schedule.Clear();
  }
  return false;
}

Application.Schedule.Reset = function() {
  $("div#new-reservation").remove();
  Application.Schedule.Clear();
  Application.Schedule.Refresh();
  return false;
}

Application.Schedule.Update = function(column) {
  var slot = Application.Schedule.Begin;
  var resource_id = slot.closest('div[data-resource]').data('resource')
  var date = slot.closest('div[data-date]').data('date')
  var column = slot.closest('div.column');
  var start = column.find('div[data-unit='+Application.Schedule.First+']').data('start');
  var end = column.find('div[data-unit='+Application.Schedule.Last+']').data('end');
  $('select#reservation_resource_id').val(resource_id);
  $('input#reservation_date').val(date);
  $('select#reservation_start_time').val(start);
  $('select#reservation_end_time').val(end);
}

Application.Schedule.Open = function() {
  var popup = $(this).find('div.popup')
  if(popup.hasClass('active')) {
    popup.removeClass('active');
  } else {
    $('div.popup.active').removeClass('active');
    popup.addClass('active');
  }
}

Application.Schedule.Page = function() {
  var url = $(this).attr('href');
  Application.Schedule.Load(url)  
  return false;
}

Application.Schedule.Resource = function() {
  var url = $(this).val();
  Application.Schedule.Load(url)  
  return false;
}

Application.Schedule.Member = function() {
  var url = $(this).val();
  Application.Schedule.Load(url)  
  return false;
}

Application.Schedule.Tab = function() {
  var url = $(this).attr('href');
  var tab = $(this).attr('class').replace('selected' ,'').replace(' ', '');
  $('div.tabs a').removeClass('selected');
  $('div.tabs a.'+tab).addClass('selected');
  Application.Schedule.Load(url);
  return false;
}

Application.Schedule.Date = function() {
  var val = $(this).datepicker("getDate");
  var id = $(this).attr('id');
  var date = val.getFullYear() + "-" + (val.getMonth() + 1) + "-" + val.getDate();
  var url = '/reservations/day?date=' + date + '&id=' + id;
  Application.Schedule.Load(url);
}

Application.Schedule.Reserve = function() {
  var url = $(this).attr('action');
  var params = $(this).serialize();
  var refresh_url = $("div.schedule-body").data('url');
  $.ajax({
    type: 'POST',
    url: url,
    data: params,
    statusCode: {
	  200: function(data) {
	    $('div.reservation-panel').replaceWith(data);
        $("div.reservation-panel input.datepicker").datepicker({ dateFormat: 'yy-mm-dd' });
        Application.Schedule.Load(refresh_url);
      },
	  201: function(data) {
  	    $('div.reservation-panel').replaceWith(data);
        $("div.reservation-panel input.datepicker").datepicker({ dateFormat: 'yy-mm-dd' });
      },
      500: function(data) {
	    alert('error');
      }
    },
  });
  return false;
}

Application.Schedule.Cancel = function() {
  var url = $(this).attr('href');
  var refresh_url = $("div.schedule-body").data('url');
  $.ajax({
    type: 'DELETE',
    url: url,
    statusCode: {
	  200: function(data) {
        Application.Schedule.Load(refresh_url, 'GET')  
        Application.Schedule.Refresh();
      },
      500: function(data) {
	    alert('error');
      }
    },
  });
  return false;
}
//HELPER FUNCTION

Application.Schedule.Load = function(url) {
  $.ajax({
    url: url,
    success: function(data) {
	  $('div.schedule-body').replaceWith(data);
      $("div.schedule input.datepicker").datepicker({ dateFormat: 'yy-mm-dd', onSelect: Application.Schedule.Date });
    }
  });
  return false;
}

Application.Schedule.Refresh = function() {
  $.ajax({
    url: '/reservations/new',
    success: function(data) {
      $('div.reservation-panel').replaceWith(data);
      $("div.reservation-panel input.datepicker").datepicker({ dateFormat: 'yy-mm-dd' });
    },
  });	
}