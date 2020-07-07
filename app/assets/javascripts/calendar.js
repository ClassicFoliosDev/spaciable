
var admin = {

  eventCalendar: function() {
    if ($('#admin_calendar').length == 0) { return }

    admin.initDates();

    calendarEl = $('#admin_calendar')
    var dataIn = calendarEl.data()

    calendarConfig = {
        displayEventEnd: true,
        timezone:"local",
        customButtons: {
          addEvent: {
            text: 'Add Event',
            click: function() {
              admin.addEvent(dataIn.path, moment())
            }
          }
        },
        header:{
          left: 'prev, next, today',
          center: 'month, agendaWeek, agendaDay',
          right: 'title',
          title: 'MMMM YYYY'
        },
        buttonText: {
          today: 'Today',
          month: 'Month',
          week: 'Week',
          day: 'Day'
        },
        views: {
          week: {
            columnHeaderFormat: 'ddd \n D',
            allDayText: 'All Day',
            displayEventEnd: true,
            agendaEventMinHeight: 15
          },
          day: {
            columnHeaderFormat: 'dddd \n D',
            allDayText: 'All Day',
            displayEventEnd: true,
            agendaEventMinHeight: 15
          }
        },
        plugins: [ 'dayGrid', 'interaction' ],
        eventSources: [admin.index_url(dataIn)],
        selectable: true,
        selectHelper: true,
        eventClick: function(event, jsEvent, view) {
            admin.showEvent(dataIn.path, "Edit Event", "Update", "PUT", dataIn.editable)
            admin.populate(event, dataIn.editable)
        },
        eventTimeFormat: 'H:mm'
      }

    // If the calendar is ediable then add extras to support editing
    if (dataIn.editable) {
      calendarConfig.select = function(start, end, allday){
          admin.addEvent(dataIn.path, start)
        },
      calendarConfig.header.center = "addEvent, month, agendaWeek, agendaDay"
    }

    calendar = calendarEl.fullCalendar(calendarConfig)
  },

  index_url: function(data){
    return data.path + '?eventable_type=' + data.type + '&eventable_id=' + data.id;
  },

  clearCalendar: function() {
    $('#admin_calendar').fullCalendar('delete'); // In case delete doesn't work.
    $('#admin_calendar').html('');
  },

  addEvent: function(path, start){
    var event = {
           start: start,
           end: moment(start).add(15, 'm'),
           location: "",
           title: ""
         }

    admin.showEvent(path, "Add Event", "Add", "POST")
    admin.populate(event)
  },

  // Populate the form with event data.  Ideally this would be
  // done when the form is invisible but some SimpleForms controls
  // must be visible for them to be controllable through JS
  populate: function(event, editable = true){
    currentEvent = event

    $('#event_id').val(event.id).prop("disabled", !editable);
    $('#event_title').val(event.title).prop("disabled", !editable);
    $('#event_location').val(event.location).prop("disabled", !editable);

    e_start_date.setDate(event.start.toDate())
    e_start_time.setDate(event.start.toDate())
    e_end_time.setDate(event.end.toDate())
    e_end_date.setDate(event.end.toDate())

    if (event.hasOwnProperty('repeat_until') &&
        event.repeat_until != null) {
      e_repeat_until.setDate(event.repeat_until)
    }
    else {
      e_repeat_until.setDate(moment().add(1, 'Y').toDate())
    }

    // clear out the resident selections
    $("#residents input[type='checkbox']").each(function() {
      this.checked = false
      // remove styling class
      $(this).parent().removeClass("checked")
    });
    // set checked for associated event residents
    if (event.hasOwnProperty('resources')) {
      $.each( event.resources, function( index, resource ){
        $("#event_residents_" + resource['resourceable_id']).prop('checked', true)
        // # Robyn - we can add class here for styling their ack status
        // that will be held in resource['status']
      });
    }

    // Populate the pulldowns.  Simple Forms builds a complex structure of
    // related controls to support pulldowns.  The only way to set their
    // content dynamically is to mimic the click/hover/click operation that
    // the user would make to select an option
    $('.event_repeat > span > span.ui-selectmenu-text').trigger( "click" )
    var opt = $('#event_repeat [value=' + (event.hasOwnProperty('repeat') ? event.repeat : "never") + ']').text()
    var control = $('#event_repeat-menu li:contains(' + opt + ')')
    control.trigger( "mouseover" )
    control.trigger( "click" )

    $('.event_reminder > span > span.ui-selectmenu-text').trigger( "click" )
    opt = $('#event_reminder [value=' + (event.hasOwnProperty('reminder') ? event.reminder : "nix") + ']').text()
    control = $('#event_reminder-menu li:contains(' + opt + ')')
    control.trigger( "mouseover" )
    control.trigger( "click" )
  },

  showEvent: function(path, title, confirm, verb, confirmable = true) {
    var $eventContainer = $('.event_details_form')
    $('body').append($eventContainer)
    var $form = $('.event')

    // add class to checked residents
    $("#residents input[type='checkbox']").each(function() {
      $(this).parent().addClass("resident-label")
      if (this.checked == true) {
        $(this).parent().addClass("checked")
      }

      $(this).click(function () {
        if (this.checked == true) {
          $(this).parent().addClass("checked")
        } else {
          $(this).parent().removeClass("checked")
        }
      })
    });

    var buttons = [
      {
        text: "Cancel",
        class: 'btn',
        click: function () {
          $(this).dialog('destroy')
        }
      }
    ]

    // If it is confirmable add the confirmation button
    if (confirmable) {
      buttons.push(
      {
        text: confirm,
        class: 'btn-send btn',
        id: 'btn_submit',
        click: function () {
          $.ajax({
            url:path,
            type: verb,
            data: $form.serialize(),
            success: function() {
                calendar.fullCalendar('refetchEvents')
            }
          });

          $(this).dialog('destroy')
          $eventContainer.hide()
        }
      })
    }

    $eventContainer.dialog({
      show: 'show',
      modal: true,
      width: 400,
      title: title,
      buttons: buttons
    }).prev().find('.ui-dialog-titlebar-close').hide()
  },

  initDates: function(){

    var dateFormat = {
      dateFormat: 'Z',
      altInput: true,
      altFormat: "d-m-Y",
      utc: true,
      enableTime: false
    }

    var timeFormat = {
      focus: false,
      static: true,
      dateFormat: 'Z',
      utc: true,
      enableTime: true,
      altInput: true,
      altFormat: "h:i K",
      noCalendar: true
    }

    e_start_date = flatpickr('#event_start_date', dateFormat)
    e_start_date.config.onValueUpdate.push(function(selectedDates, dateStr, instance)
    {
      diff = moment(selectedDates[0]).diff(currentEvent.start.clone().startOf('day'))
      currentEvent.start.add(diff)
      currentEvent.end.add(diff)
      admin.syncDates()
    })

    e_start_time = flatpickr('#event_start_time', timeFormat)
    e_start_time.config.onValueUpdate.push(function(selectedDates, dateStr, instance){
      diff = moment(selectedDates[0]).diff(currentEvent.start)
      currentEvent.start.add(diff)
      currentEvent.end.add(diff)
      admin.syncDates()
    })

    e_end_date = flatpickr('#event_end_date', dateFormat)
    e_end_date.config.onValueUpdate.push(function(selectedDates, dateStr, instance)
    {
      diff = moment(selectedDates[0]).diff(currentEvent.end.clone().startOf('day'))
      currentEvent.end.add(diff) // update event end
      admin.syncDates()
    })

    e_end_time = flatpickr('#event_end_time', timeFormat)
    e_end_time.config.onValueUpdate.push(function(selectedDates, dateStr, instance){
      diff = moment(selectedDates[0]).diff(currentEvent.end)
      currentEvent.end.add(diff)
      admin.syncDates()
    })

    e_repeat_until = flatpickr('#event_repeat_until', dateFormat)
  },

  syncDates: function(){
    e_start_date.setDate(currentEvent.start.toDate(), false)
    e_start_time.setDate(currentEvent.start.toDate(), false)
    e_end_date.setDate(currentEvent.end.toDate(), false)
    e_end_time.setDate(currentEvent.end.toDate(), false)
  }

}

$(document).on('turbolinks:load', admin.eventCalendar);
$(document).on('turbolinks:before-cache', admin.clearCalendar)
