
var homeowner = {

  eventCalendar: function() {
    if ($('#homeowner_calendar').length == 0) { return }

    homeowner.initDates();

    calendarEl = $('#homeowner_calendar')
    var dataIn = calendarEl.data()

    calendarConfig = {
        displayEventEnd: true,
        timezone:"local",
        customButtons: {
          addEvent: {
            text: 'Add Event',
            click: function() {
              homeowner.addEvent(dataIn.path, moment())
            }
          }
        },
        header:{
          left: 'today, prev, next',
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
          month: {
            timeFormat: 'H:mm'
          },
          week: {
            columnHeaderFormat: 'ddd \n D',
            allDayText: 'All Day',
            slotLabelFormat: 'h A',
            agendaEventMinHeight: 15,
            displayEventTime: false
          },
          day: {
            columnHeaderFormat: 'dddd \n D',
            allDayText: 'All Day',
            slotLabelFormat: 'h A',
            agendaEventMinHeight: 15,
            displayEventTime: false
          }
        },
        plugins: [ 'dayGrid', 'interaction' ],
        eventSources: [homeowner.index_url(dataIn)],
        selectable: true,
        selectHelper: true,
        eventClick: function(event, jsEvent, view) {
          homeowner.showEvent(event, dataIn)
        }
      }

    // If the calendar is editable then add extras to support editing
    if (dataIn.editable) {
      calendarConfig.select = function(start, end, allday){
          homeowner.addEvent(dataIn.path, start)
        },
      calendarConfig.header.center = "addEvent"
    }

    calendar = calendarEl.fullCalendar(calendarConfig)
    homeowner.initialise()
  },

  index_url: function(data){
    return data.path + '?eventable_type=' + data.type + '&eventable_id=' + data.id;
  },

  clearCalendar: function() {
    $('#homeowner_calendar').fullCalendar('delete');
    $('#homeowner_calendar').html('');
  },

  addEvent: function(path, start){
    var event = {
           start: start.startOf('minute').local(),
           end: moment(start).add(15, 'm'),
           location: "",
           title: "",
           new: true,
           editable: true
         }

    homeowner.showEvent(event, dataIn)
  },

  populate: function(event){
    currentEvent = event
    $('#event_id').val(event.id).prop("disabled", !event.editable);
    $('#event_title').val(event.title).prop("disabled", !event.editable);
    $('#event_location').val(event.location).prop("disabled", !event.editable);

    p_start = moment(event.homeowner.proposed_start)
    p_end = moment(event.homeowner.proposed_end)
    $('#proposed_start_date').text(p_start.local().format('DD-MM-YYYY'))
    $('#proposed_start_time').text(p_start.local().format('hh:mm A'))
    $('#proposed_end_date').text(p_end.local().format('hh:mm A'))
    $('#proposed_end_time').text(p_end.local().format('DD-MM-YYYY'))

    e_start_date.setDate(event.start.toDate())
    e_start_time.setDate(event.start.toDate())
    e_end_time.setDate(event.end.toDate())
    e_end_date.setDate(event.end.toDate())

    homeowner.disableDates(!event.editable)
    homeowner.setResponses(event.homeowner.status)
  },

  showEvent: function(event, dataIn) {
    homeowner.populate(event)

    var $eventContainer = $('.event_details_form')
    $('body').append($eventContainer)
    var $form = $('.event')

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
    if (event.editable) {
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
                admin.refreshEvents()
            }
          });

          $(this).dialog('destroy')
        }
      })
    }

    // If it is editable add the confirmation button
    if (event.editable) {
      buttons.push(
      {
        text: (event.new ? "Add" : "Update"),
        class: 'btn-send btn',
        id: 'btn_submit',
        click: function () {
          $eventContainer.hide()

          $(this).dialog('destroy')

          $.ajax({
            url:dataIn.path,
            type: (event.new ? "POST" : "PUT"),
            data: $form.serialize(),
            success: function() {
                homeowner.refreshEvents()
            }
          })
        }
      })
    }

    $eventContainer.dialog({
      show: 'show',
      modal: true,
      width: 500,
      title: homeowner.title(event),
      buttons: buttons
    }).prev().find('.ui-dialog-titlebar-close').hide()
  },

  title: function(event){
    return event.homeowner.status.charAt(0).toUpperCase() +
           event.homeowner.status.slice(1) + " on " +
           moment(homeowner.status_updated_at).local().format('DD-MM-YYYY hh:mm A')
  },

  initialise: function(){
    $("#accept_event").click(function() {
      homeowner.respond($(this))
    })

    $("#decline_event").click(function() {
      homeowner.respond($(this))
    })

    $("#change_event").click(function() {
      homeowner.setResponses('changing')
      homeowner.disableDates(false)
    })

    $("#save_change").click(function() {
      homeowner.respond($(this))
    })
  },

  initDates: function(){

    var dateFormat = {
      dateFormat: 'Z',
      altInput: true,
      altFormat: "d-m-Y",
      utc: true,
      enableTime: false,
      monthSelectorType: "static"
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

    // Adjust dependent date times.  i.e. when start date/time is changed, then move the
    // end date/time to preserve the duration.
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

  // When usign AltFormats, FlatPickr dates create new fields
  // directly after the element they are associated with and hide
  // the original.  Disabling needs to be performed on the
  // replacement field
  disableDates: function(disabled){
    $('#event_start_date').next().prop("disabled", disabled);
    $('#event_start_time').next().prop("disabled", disabled);
    $('#event_end_date').next().prop("disabled", disabled);
    $('#event_end_time').next().prop("disabled", disabled);
  },

  setResponses: function(status){
    $("#accept_event").show()
    $("#decline_event").show()
    $("#change_event").show()
    $("#save_change").hide()
    $(".proposed_datetime").hide()

    if (status == 'accepted') {
      $("#accept_event").hide()
    }
    else if (status == 'declined') {
      $("#accept_event").hide()
      $("#decline_event").hide()
    } else if (status == 'changing') {
      $("#accept_event").hide()
      $("#decline_event").hide()
      $("#change_event").hide()
      $("#save_change").show()
    } else if (status == 'reproposed') {
      $("#accept_event").hide()
      $("#decline_event").hide()
      $("#change_event").show()
      $("#save_change").hide()
      $(".proposed_datetime").show()
    }

  },

  respond: function(response){
    homeowner.removeDialog(response.closest(".ui-dialog"))

    $.post({
      url: $('.event_details_form').data('response'),
      data: {event_id: currentEvent.id,
             resourceable_type: currentEvent.homeowner.resourceable_type,
             resourceable_id: currentEvent.homeowner.resourceable_id,
             status: response.data('status'),
             proposed_start: currentEvent.start.toDate(),
             proposed_end: currentEvent.end.toDate()
           },
      dataType: 'json'
    }).done(function (results) {
      admin.refreshEvents()
    }).fail(function (response) {
      flash("Failed", 'alert')
    })
  },

  refreshEvents: function(){
    calendar.fullCalendar('refetchEvents')
  },

  removeDialog: function(dialog){
    dialog.empty();
    dialog.remove();
  }
}

$(document).on('turbolinks:before-cache', homeowner.clearCalendar)

$(document).on('turbolinks:load', function () {
  homeowner.eventCalendar()

  if ($(window).innerWidth() < 760) {
    $(".fc-left").contents().appendTo($(".fc-center"))
    $(".fc-month-button, .fc-agendaWeek-button, .fc-agendaDay-button").appendTo($(".fc-left"))
  }
})
