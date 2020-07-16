
var admin = {

  eventCalendar: function() {
    if ($('#admin_calendar').length == 0) { return }

    admin.initDates();
    admin.initControls();

    calendarEl = $('#admin_calendar')
    var dataIn = calendarEl.data()

    calendarConfig = {
        displayEventEnd: true,
        timezone:"local",
        customButtons: {
          addEvent: {
            text: 'Add Event',
            click: function() {
              admin.newEvent(dataIn, moment())
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
            event.new = false
            if (!event.hasOwnProperty('editable')) { event.editable = true }
            admin.updateEvent(event, dataIn)
        },
        eventTimeFormat: 'H:mm'
      }

    // If the calendar is ediable then add extras to support editing
    if (dataIn.editable) {
      calendarConfig.select = function(start, end, allday){
          admin.newEvent(dataIn, start)
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

  newEvent: function(dataIn, start){
    var event = {
           start: start,
           end: moment(start).add(15, 'm'),
           location: "",
           title: "",
           new: true,
           editable: true,
           repeater: false,
           master_id: null
         }

    admin.addEvent(event, dataIn)
  },

  addEvent(event, dataIn)
  {
   admin.showEvent(event, dataIn)
  },

  updateEvent(event, dataIn)
  {
    admin.showEvent(event, dataIn)
  },

  showEvent: function(event, dataIn) {
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

    // If it is editable add the confirmation button
    if (event.editable) {
      buttons.push(
      {
        text: (event.new ? "Add" : "Update"),
        class: 'btn-send btn',
        id: 'btn_submit',
        click: function () {
          $eventContainer.hide()

          if (event.repeater) {
            admin.confirm(event, dataIn, $(this))
          }
          else {
            $(this).dialog('destroy')

            $.ajax({
              url:dataIn.path,
              type: (event.new ? "POST" : "PUT"),
              data: $form.serialize(),
              success: function() {
                  admin.refreshEvents()
              }
            })
          }
        }
      })
    }

    // If its not new - add the delete option
    if (!event.new) {
      buttons.push(
      {
        text: '',
        class: 'btn delete-btn',
        id: 'btn_event_delete',
        click: function () {
          admin.confirm(event, dataIn, $(this), false)
          $(".ui-widget-overlay").css({'background': 'none', 'background-color': '#000', 'opacity': '0.5'})
        }
      })
    }

    $eventContainer.dialog({
      show: 'show',
      modal: true,
      width: 650,
      title: (event.new? "Add" : "Edit") + " Event",
      buttons: buttons
    }).prev().find('.ui-dialog-titlebar-close').hide()

    $('#btn_event_delete').appendTo($('.ui-dialog-titlebar-close').parent()).html("<i class='fa fa-trash-o'></i>")
    $('.ui-dialog-title').css('line-height', '28px')

    admin.populate(event)
  },

  // Populate the form with event data.  Ideally this would be
  // done when the form is invisible but some SimpleForms controls
  // must be visible for them to be controllable through JS
  populate: function(event){
    currentEvent = event

    $('#event_id').val(event.id)
    $('#event_master_id').val(event.master_id)
    $('#event_title').val(event.title).prop("disabled", !event.editable);
    $('#event_location').val(event.location).prop("disabled", !event.editable);

    e_start_date.setDate(event.start.toDate())
    e_start_time.setDate(event.start.toDate())
    e_end_time.setDate(event.end.toDate())
    e_end_date.setDate(event.end.toDate())

    if (event.hasOwnProperty('repeat_until') &&
        event.repeat_until != null) {
      e_repeat_until.setDate(event.repeat_until)
    }
    else {
      e_repeat_until.setDate(moment().add(1, 'M').toDate())
    }

    admin.populateResidents(event)

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

  populateResidents(event) {

    // clear out any resident selections
    $("#residents input[type='checkbox']").each(function() {
      if (this.checked) {
        $(this).trigger( "click" )
      }
    });

    // set checked for associated event residents
    if (event.hasOwnProperty('resources')) {
      $.each( event.resources, function( index, resource ){
        $("#event_residents_" + resource['resourceable_id']).trigger( "click" )
      });
    }
  },

  // Show the relevant confirmation dialog
  confirm: function(event, dataIn, parent, edit=true){

    parent.dialog('close') // close the parent

    var $confirmContainer = (event.repeater ? $('.repeat_event_form') : $('.confirm_event_delete_form'))
    $('body').append($confirmContainer)
    admin.initRepeatDialog(event)

    $confirmContainer.dialog({
      show: 'show',
      modal: true,
      width: 400,
      title: (edit ? "Edit" : "Delete") + (event.repeater ? " Repeating" : "") + " Event",
      buttons: [
        {
          text: "Cancel",
          class: 'btn',
          click: function () {
            $(this).dialog('destroy')
            parent.dialog('open') // reopen the parent
          }
        },
        {
          text: "Confirm",
          class: 'btn-send btn',
          id: 'btn_submit',
          click: function () {
            parent.dialog('destroy')
            $(this).dialog('destroy')

            if (edit) {
              $.ajax({
                url:dataIn.path + '?repeat_opt=' + $('#repeat_event_form').find("input:checked").val(),
                type: "PUT",
                data: parent.find('form').serialize(),
                success: function() {
                    admin.refreshEvents()
                }
              })
            } else {
              $.ajax({
                url:dataIn.path + '/' + $("#event_id").val() + '?repeat_opt=' + $('#repeat_event_form').find("input:checked").val(),
                type: "DELETE",
                success: function() {
                    admin.refreshEvents()
                }
              })
            }
          }
        }]
    }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
  },

  // The reapeat event form options are dependent upon if the event has had a change
  // of repeat options.
  initRepeatDialog: function(event){

    $('#repeat_event_form input').each(function() {
      $(this).show()
      $('label[for=' + $(this).prop('id') + ']').show()
      $(this).prop('checked', false)
    })

    if ($('#event_repeat').val() == event.repeat &&
        $('#event_repeat_until').val() == event.repeat_until) {
      $('#this_event').prop('checked', true)
    } else {
      $('#this_and_following').prop('checked', true)
      $('#this_event').hide()
      $('label[for=this_event]').hide()
    }
  },

  refreshEvents: function(){
    calendar.fullCalendar('refetchEvents')
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

  // Add click handlers to all the resident entries.
  initControls: function() {
    $("#residents input[type='checkbox']").each(function() {
      $(this).parent().addClass("resident-label")
      $(this).change(function () {
        this.checked ? $(this).parent().addClass("checked") :
                       $(this).parent().removeClass("checked")
      })
    });
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

$(document).on('turbolinks:load', function () {
  if ($("#event_repeat").length) {
    if ($("#event_repeat")[0].value == "never") {
      $("#repeat_until").hide()
    }
  }
})

$(document).on('click', '#event_repeat-menu', function (event) {
  ($("#event_repeat")[0].value == "never") ?
    $("#repeat_until").hide() :
    $("#repeat_until").show()
})
