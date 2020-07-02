
var homeowner = {

  eventCalendar: function() {
    if ($('#homeowner_calendar').length == 0) { return }

    calendarEl = $('#homeowner_calendar')
    var dataIn = calendarEl.data()

    calendarConfig = {
        displayEventEnd: true,
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
          homeowner.populate(event, dataIn.editable)
          homeowner.showEvent(dataIn.path, "Edit Event", "Update", "PUT", dataIn.editable)
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
  },

  index_url: function(data){
    return data.path + '?eventable_type=' + data.type + '&eventable_id=' + data.id;
  },

  clearCalendar: function() {
    $('#homeowner_calendar').fullCalendar('delete'); // In case delete doesn't work.
    $('#homeowner_calendar').html('');
  },

  addEvent: function(path, start){
    var event = {
           start: start,
           end: moment(start).add(15, 'm'),
           location: "",
           title: ""
         }

    homeowner.populate(event)
    homeowner.showEvent(path, "Add Event", "Add", "POST")
  },
  populate: function(event, editable = true){
    $('#event_id').val(event.id).prop("disabled", !editable);
    $('#event_title').val(event.title).prop("disabled", !editable);
    $('#event_location').val(event.location).prop("disabled", !editable);
    $('#event_start').val($.fullCalendar.formatDate(event.start, "Y-MM-DD HH:mm:ss")).prop("disabled", !editable);
    $('#event_end').val($.fullCalendar.formatDate(event.end, "Y-MM-DD HH:mm:ss")).prop("disabled", !editable);
  },

  showEvent: function(path, title, confirm, verb, confirmable = true) {
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
  }
}

$(document).on('turbolinks:load', homeowner.eventCalendar);
$(document).on('turbolinks:before-cache', homeowner.clearCalendar)

$(document).on('turbolinks:load', function () {
  if ($(window).innerWidth() < 760) {
    $(".fc-left").contents().appendTo($(".fc-center"))
    $(".fc-month-button, .fc-agendaWeek-button, .fc-agendaDay-button").appendTo($(".fc-left"))
  }
})
