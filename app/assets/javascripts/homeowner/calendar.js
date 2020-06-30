
var homeowner = {

  eventCalendar: function() {
    if ($('#homeowner_calendar').length == 0) { return }

    calendarEl = $('#homeowner_calendar')
    var dataIn = calendarEl.data()
    calendar = calendarEl.fullCalendar(
      {
        editable: true,
        customButtons: {
          addEvent: {
            text: 'Add Event',
            click: function() {
              homeowner.addEvent(dataIn.path, moment())
            }
          }
        },
        header:{
          left: 'prev, next, today',
          center: 'addEvent',
          right: 'month, agendaWeek, agendaDay'
        },
        views: {
          week: {
            columnHeaderFormat: 'DD/MM'
          }
        },
        plugins: [ 'dayGrid', 'interaction' ],
        eventSources: [homeowner.index_url(dataIn)],
        selectable: true,
        selectHelper: true,
        select: function(start, end, allday){
          homeowner.addEvent(dataIn.path, start)
        },
        editable: true,
        eventResize: function(event){
          homeowner.updateEvent(event, $.fullCalendar, dataIn)
        },
        eventDrop: function(event){
          homeowner.updateEvent(event, $.fullCalendar, dataIn)
        },
        eventClick: function(event, jsEvent, view) {
          homeowner.populate(event)
          homeowner.showEvent(dataIn.path, "Edit Event", "Update", "PUT")
        }
      })
  },

  index_url: function(data){
    return data.path + '?eventable_type=' + data.type + '&eventable_id=' + data.id;
  },

  updateEvent: function(event, calendar, data){
    var start = calendar.formatDate(event.start, "Y-MM-DD HH:mm:ss")
    var end = calendar.formatDate(event.end, "Y-MM-DD HH:mm:ss")
    var title = event.title
    var id = event.id
    $.ajax({
      url:data.path,
      type: "PUT",
      data: {event:
              {eventable_type: data.type,
               eventable_id: data.id,
               title: event.title,
               location: event.location,
               start: start,
               end: end,
               id: event.id}
            },
      success: function() {
        calendar.fullCalendar('refetchEvents')
      }
    });
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
  populate: function(event){
    $('#event_id').val(event.id)
    $('#event_title').val(event.title)
    $('#event_location').val(event.location)
    $('#event_start').val($.fullCalendar.formatDate(event.start, "Y-MM-DD HH:mm:ss"))
    $('#event_end').val($.fullCalendar.formatDate(event.end, "Y-MM-DD HH:mm:ss"))
  },
  showEvent: function(path, title, confirm, verb) {
    var $eventContainer = $('.event_details_form')
    $('body').append($eventContainer)
    var $form = $('.event')

    $eventContainer.dialog({
      show: 'show',
      modal: true,
      width: 400,
      title: title,
      buttons: [
        {
          text: "Cancel",
          class: 'btn',
          click: function () {
            $(this).dialog('destroy')
          }
        },
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
        }
      ]
    }).prev().find('.ui-dialog-titlebar-close').hide()
  }
}

$(document).on('turbolinks:load', homeowner.eventCalendar);
$(document).on('turbolinks:before-cache', homeowner.clearCalendar)
