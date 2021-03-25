
var admin = {

  eventCalendar: function() {
    if ($('#admin_calendar').length == 0) { return }

    admin.initDates();

    calendarEl = $('#admin_calendar')
    var dataIn = calendarEl.data()

    calendarConfig = {
        displayEventEnd: false,
        timezone:"local",
        customButtons: {
          addEvent: {
            text: 'Add ' + $("#admin_calendar").data("type") + ' Event',
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
            if (!event.hasOwnProperty('writable')) { event.writable = true }
            admin.updateEvent(event, dataIn)
        },
        eventTimeFormat: 'H:mm',
        eventRender: function(event, element, view) {
          if (!$("#" + event.eventable_type.toLowerCase()).prop('checked')) {
            return false
          }

          // Event type indicator
          element.children(".fc-content").addClass(event.eventable_type + "_bg")
          element.children(".fc-bg").addClass(event.eventable_type + "_bg")
          element.find('.fc-title').text(event.qualified_title)

          var eventEnd = moment(event.end)
          var now = moment()

          if (event.repeater) {
            element.addClass("repeat-event")
          }

          event.resources.forEach(function(resource) {
            if(resource.status == "rescheduled") {
              element.addClass("rescheduled-datetime")
            }
            if(event.eventable_type == "Plot" ||
              ($("#admin_calendar").data("type") == "Plot" &&
               $("#admin_calendar").data("id") == resource.resourceable_id)) {
              element.children(".fc-content").append("<span class='" + resource.status + "'></span>")
            }
          })

          tooltip_id = 'tooltip' + event.id
          element.attr('id', tooltip_id)
          element.attr('title', event.qualified_title)


        },
        eventAfterAllRender: function(){
          admin.preloadEvent()
        }
      }

    // If the calendar is editable then add extras to support editing
    if (dataIn.editable) {
      calendarConfig.select = function(start, end, allday){
          admin.newEvent(dataIn, start)
        },
      calendarConfig.header.center = "addEvent, month, agendaWeek, agendaDay"
    }

    calendar = calendarEl.fullCalendar(calendarConfig)

    admin.loadFilter()
 },

 loadFilter: function()
 {
    $(".fc-center").append("<span id='filter'/>")

    filters = ["Development", "Phase", "Plot"]
    filters.forEach(function(filter){
      lower = filter.toLowerCase()
      $("#filter").append("<label class='container'>" + filter + "<input id='" + lower + "' type='checkbox' checked='checked'><span class='checkmark " + filter + "'></span></label>")
      $("#" + lower).click(function(){
        calendar.fullCalendar('refetchEvents')
      })
    })
 },

  // If there is preload event specified then display it.  This runs in
  // 2 stages.  This function is called whenever the calendar rerenders
  // so it has to be controlled.  Firstly check if the event in in the
  // current dataset and if not, then go the preload date and try again
  preloadEvent: function()
  {
    if (typeof hasRun !== 'undefined') { return }

    var preload_id = $('#admin_calendar').data('preload_id')
    var preload_date = $('#admin_calendar').data('preload_date')

    if (typeof preload_id == 'undefined' || typeof preload_date == 'undefined') { return }

    event = calendarEl.fullCalendar('clientEvents', preload_id)[0]
    if (typeof event !== 'undefined') {
      admin.showEvent(event, calendarEl.data())
    } else if (typeof hasGoneToDate == 'undefined'){
      calendarEl.fullCalendar('gotoDate', preload_date)
      hasGoneToDate = true
      return
    }

    hasRun = true
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
           start: start.startOf('minute').local(),
           end: moment(start).add(15, 'm'),
           location: "",
           title: "",
           new: true,
           writable: true,
           repeater: false,
           master_id: null
         }

    admin.addEvent(event, dataIn)
  },

  addEvent: function(event, dataIn)
  {
   admin.showEvent(event, dataIn)
  },

  updateEvent: function(event, dataIn)
  {
    admin.showEvent(event, dataIn)
  },

  showEvent: function(event, dataIn) {

    if ($(".ui-dialog").length == 1) { return }

    $(".proposed_datetime").hide()
    admin.scrub()

    $.post({
      // Get all the POSSIBLE resources for this event
      url: '/event_resources/' +
           (event.hasOwnProperty('eventable_type') ? event.eventable_type : $("#admin_calendar").data("type")) + '/' +
           (event.hasOwnProperty('eventable_id') ? event.eventable_id : $("#admin_calendar").data("id")),
      dataType: 'json',
      success: function (response) {

        // The resources are dynaically created within the #resouces span
        var $table = $('#resources table')
        $table.find('tr').remove()

        // go through all the resources
        var arrayLength = response.length;
        for (var i = 0; i < arrayLength; i++) {
          // has this resource been invited already?
          invited = false
          if (event.resources != undefined) {
            event.resources.forEach(function(r) { invited = invited || (r['resourceable_id'] == response[i].id) } )
          }

          // build the resource entry
          resource_id = response[i]["id"]
          etype = event.eventable_type != null ? event.eventable_type  : $("#admin_calendar").data('type')
          identity = (etype == "Plot" ? "" : "Plot ")
          identity += response[i]["ident"]
          var $row = $table.append("<tr>").find('tr:last')
          $row.append("<td class='" + etype + "-col'>" +
                         "<label class='resource-label' for='event_resources_" + resource_id + "'>" +
                           "<input type='checkbox' value='" + resource_id + "' name='event[resources][]' id='event_resources_" + resource_id + "'>" +
                           "<label class='collection_check_boxes' for='event_resources_" + resource_id + "'>" + identity + "</label>" +
                         "</label>" +
                       "</td>")
          $row.append("<td class='" + etype + "-col'>" +
                        "<label id='status_label_" + resource_id + "' class='" + etype + "-status-label'>&nbsp;</label>" +
                      "</td>")

          if (etype == "Phase") {
            status = (response[i]["status"] == null ? '&nbsp;' : response[i]["status"])
            $row.append("<td class='" + etype + "-col'><center><label class='plot-status-label'>" + status + "</label></td>")
          }

          $row.append("<td class='" + etype + "-col'>")

          if (invited) {
            $row.addClass('invited')
          }
        }

        // add the form
        var $eventContainer = $('.event_details_form')
        $('body').append($eventContainer)
        var $form = $('.event')

        var buttons = [
          {
            text: "Cancel",
            class: 'btn close_event_dialog',
            click: function () {
              $(this).dialog('destroy')
            }
          }
        ]

        // If it is writable add the confirmation button
        if (event.writable) {
          buttons.push(
          {
            text: (event.new ? "Add" : "Update"),
            class: 'btn-send btn',
            id: 'btn_submit',
            click: function () {
              if (!admin.validate()) {
                return
              }

              $eventContainer.hide()

              if (event.repeater) {
                admin.confirm(event, dataIn, $(this), true)
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
        if (!event.new && $('#admin_calendar').data('deletable')) {
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

        // display the form
        $eventContainer.dialog({
          show: 'show',
          modal: true,
          width: 650,
          title: (event.new ? "Add " : "Edit ") +
                 (event.hasOwnProperty('eventable_type') ? event.eventable_type : $("#admin_calendar").data("type")) +
                 " Event " +
                 (event.signature == "" || event.new ? "" : (" for " + event.signature)),
          buttons: buttons
        }).prev().find('.ui-dialog-titlebar-close').hide()

        if ($('#admin_calendar').data('deletable')) {
          $('#btn_event_delete').appendTo($('.ui-dialog-titlebar-close').parent()).html("<i class='fa fa-trash-o'></i>")
        }
        $('.ui-dialog-title').css('line-height', '28px')

        // populate the form with the data from this event
        admin.populate(event, dataIn)
        admin.initControls();

        // Select all for new Plot events
        if ($("#event_eventable_type").val() == "Plot" && event.new) {
           $(".select-all-resources").trigger('click')
        }
      }
    })

  },

  // Populate the form with event data.  Ideally this would be
  // done when the form is invisible but some SimpleForms controls
  // must be visible for them to be controllable through JS
  populate: function(event, dataIn){
    currentEvent = event

    $('#event_id').val(event.id)
    $('#event_master_id').val(event.master_id)
    $('#event_title').val(event.title).prop("disabled", !event.writable);
    $('#event_location').val(event.location).prop("disabled", !event.writable);

    e_start_date.setDate(event.start.toDate())
    e_start_time.setDate(event.start.toDate())
    e_end_time.setDate(event.end.toDate())
    e_end_date.setDate(event.end.toDate())
    $('#event_start_date').next().prop("disabled", !event.writable)
    $('#event_start_time').next().prop("disabled", !event.writable)
    $('#event_end_date').next().prop("disabled", !event.writable)
    $('#event_end_time').next().prop("disabled", !event.writable)

    if (event.hasOwnProperty('repeat_until') &&
        event.repeat_until != null) {
      e_repeat_until.setDate(event.repeat_until)
    }
    else {
      e_repeat_until.setDate(moment().add(1, 'M').toDate())
    }
    $('#event_repeat_until').next().prop("disabled", !event.writable)

    $('#event_notify').prop('checked', event.notify)

    // Populate the pulldowns.  Simple Forms builds a complex structure of
    // related controls to support pulldowns.  The only way to set their
    // content dynamically is to mimic the click/hover/click operation that
    // the user would make to select an option
    $('.event_repeat > span > span.ui-selectmenu-text').trigger( "click" )
    var opt = $('#event_repeat [value=' + (event.hasOwnProperty('repeat') ? event.repeat : "never") + ']').text()
    var control = $('#event_repeat-menu li:contains(' + opt + ')')
    control.trigger( "mouseover" )
    control.trigger( "click" )
    admin.disablePulldown($('#event_repeat-button'), !event.writable)

    $('#event_repeat-button').prop("disabled", !event.writable);

    $('.event_reminder > span > span.ui-selectmenu-text').trigger( "click" )
    opt = $('#event_reminder [value=' + (event.hasOwnProperty('reminder') ? event.reminder : "nix") + ']').text()
    control = $('#event_reminder-menu li:contains(' + opt + ')')
    control.trigger( "mouseover" )
    control.trigger( "click" )
    admin.disablePulldown($('#event_reminder-button'), !event.writable)

    if (event.new) {
      $("#event_eventable_type").val($("#admin_calendar").data("type"))
      $("#event_eventable_id").val($("#admin_calendar").data("id"))
    } else {
      $("#event_eventable_type").val(event.eventable_type)
      $("#event_eventable_id").val(event.eventable_id)
    }

    $("#event_id").val(event.id)
    $("#event_master_id").val(event.master_id)
    $("#event_resource_type").val($("#event_eventable_type").val() == "Plot" ? "Resident" : "Plot")
    $('#resources_type').text("Select " + ($("#event_eventable_type").val() == "Plot" ? 'Attendees' : 'Plots'))

    admin.populateResources(event)
  },

  // populate the resources using the event.
  populateResources: function(event) {

    // clear out any resident selections - ie unclick any checked boxes
    $("#resources input[type='checkbox']").each(function() {
      if (this.checked) {
        $(this).trigger( "click" )
      }
    });

    // set status for associated event resources
    if (event.hasOwnProperty('resources')) {
      $.each( event.resources, function( index, resource ){
        res = admin.resource(resource['resourceable_id'])
        label = $("#status_label_" + resource['resourceable_id'])
        label.addClass(resource.status).text(admin.capitalize(resource.status)).data("status", resource.status)
        res.parent().children("input[type='checkbox']").trigger('click')
      });
    }

    $(".select-all-resources, .select-all-comp, .comp-info, .select-all-res, .res-info").hide()

    // add the buttons for each resource
    if ($("#event_eventable_type").val() != "Development") {
      $(".select-all-resources").show().prop( "enabled", true );
      $("#resources table tr").each(function () {
        if (event.writable) {
          // add invite/uninvite buttons
          col = $(this).find("td:last")
          if($(this).hasClass("invited")) {
            col.append("<button class='invite-btn uninvite-resource-btn'>Remove</button>")
          } else {
            col.append("<button class='invite-btn invite-resource-btn'>Invite</button>")
          }
        }
      })
    } else {
      // invite all uninvited resources
      $("#resources input[type='checkbox']:not(:checked)").each(function() {
        this.checked = true
        $("#status_label_" + this.value).text("invited").addClass('invited').prop("checked", true)
        $("#status_label_" + this.value).closest('tr').addClass('invited')
      })
    }

     $(".select-all-resources, .select-all-comp, .comp-info, .select-all-res, .res-info").hide()

    admin.showSelectAlls()
    admin.showProposed(event)
    admin.showResources(event)

    if (event.writable) {$("#accept_reschedule").show()} else {$("#accept_reschedule").hide()}
  },

  // The display of the resources is dependant upon the event and the source
  showResources: function(event){

    if ($("#event_eventable_type").val() == "Development") {
      $("#resources_label").hide()
      if (event.new) {
        $(".resources").hide()
      } else {
        $("#dev_invited").text($("#resources tr").length)
        $("#dev_accepted").text($("#resources .accepted").length)
        $("#dev_declined").text($("#resources .declined").length)
        $(".resources").show()
        $("#dev_counts").show()
      }
    } else {
      $("#dev_counts").hide()
      $("#resources_label").show()
      $(".resources").show()
    }
  },

  resource: function(id){
    return $("#event_resources_" + id)
  },

  disablePulldown: function(pulldown, disable) {
    var classes = "ui-selectmenu-disabled ui-state-disabled"
    if (disable) {
      pulldown.addClass(classes)
    } else {
      pulldown.removeClass(classes)
    }
  },

  // Show the relevant confirmation dialog
  confirm: function(event, dataIn, parent, edit){

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

  // The repeat event form options are dependent upon if the event has had a change
  // of repeat options.
  initRepeatDialog: function(event){

    $('#repeat_event_form input').each(function() {
      $(this).show()
      $('label[for=' + $(this).prop('id') + ']').show()
      $(this).prop('checked', false)
    })

    if ($('#event_repeat').val() == event.repeat &&
        moment(event.repeat_until).local().format() ==
        moment($('#event_repeat_until').val()).local().format()) {
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

  initControls: function() {
    $("#resources input[type='checkbox']").each(function() {
      $(this).change(function () {
        if (this.checked) {
          $(this).closest('tr').addClass("invited")
          label = $("#status_label_" + this.value)
          if (label.data("status") == undefined){
            $("#status_label_" + this.value).text('invited').addClass("invited")
          } else {
            label.text(label.data("status")).addClass(label.data("status"))
          }
          if($("#status_label_" + this.value).hasClass("rescheduled")) { $('.proposed_datetime').show() }
        } else {
          $(this).closest('tr').removeClass("invited")
          // If this resource was re-proposing, then remove the reproposed date
          if($("#status_label_" + this.value).hasClass("rescheduled")) { $('.proposed_datetime').hide() }
          $("#status_label_" + this.value).html("&nbsp;").removeClass("invited rescheduled accepted declined")

        }
      })
    });
  },

  syncDates: function(){
    e_start_date.setDate(currentEvent.start.toDate(), false)
    e_start_time.setDate(currentEvent.start.toDate(), false)
    e_end_date.setDate(currentEvent.end.toDate(), false)
    e_end_time.setDate(currentEvent.end.toDate(), false)
    admin.checkDates()
  },

  checkDates: function(){
    // add styling class to date fields if invalid
    if (currentEvent.end > currentEvent.start) {
      $(".event_end_date, .event_start_date").removeClass('field_with_errors');
      $("#date_error").remove()
    } else if ($(".event_end_date").hasClass("field_with_errors") == false ) {
      $(".event_end_date, .event_start_date").addClass('field_with_errors');
      $(".event_start_date").append( "<span id='date_error' class='error'>must be before end date.</span>")
    }
  },

  showProposed: function(event){

    if (event.proposed_start == null) { return }

    $(".proposed_datetime").show()
    $(".proposed_datetime").data('proposer', event.resourceable_id)

    p_start = moment(event.proposed_start)
    p_end = moment(event.proposed_end)
    $('#proposed_start_date').text(p_start.local().format('DD-MM-YYYY'))
    $('#proposed_start_time').text(p_start.local().format('h:mm A'))
    $('#proposed_end_time').text(p_end.local().format('h:mm A'))
    $('#proposed_end_date').text(p_end.local().format('DD-MM-YYYY'))

    // if the reproposed datetime is approve then update the event datetime,
    $("#accept_reschedule").click(function() {
      admin.acceptReschedule()
    })
  },

  acceptReschedule: function() {
    e_start_date.setDate(p_start.toDate())
    e_start_time.setDate(p_start.toDate())
    e_end_time.setDate(p_end.toDate())
    e_end_date.setDate(p_end.toDate())
    $(".proposed_datetime").hide()
    proposer = $(".proposed_datetime").data('proposer')
    //admin.setResidentStatus(admin.resident(proposer), 'invited')
    $("button[data-resident='" + proposer + "']").remove()
  },

  validate: function() {
    admin.scrub()
    valid = true

    title = $("#event_title")
    if( !title.val() ) {
      if (!$('#title_error').length) {
        title.parents('div').addClass('field_with_errors');
        title.after( "<span id='title_error' class='error'>is required, and must not be blank.</span>")
      }
      valid = false
    }

    if ($("#resources tr.invited").length == 0){
      valid = false
      $("#resources").addClass('field_with_errors')
      $(".resources").append( "<span id='resource_error' class='error'>At least 1 must be invited.</span>")
    }

    admin.checkDates()
    valid = valid && (currentEvent.start < currentEvent.end);

    return valid
  },

  // Remove any error formatting from validated fields
  scrub: function() {
    $("#event_title").parents('div').removeClass('field_with_errors')
    $("#title_error").remove()

    // Remove any date invalidations
    $(".event_end_date, .event_start_date").removeClass('field_with_errors');
    $("#date_error").remove()

    // resource invalidations
    $("#resources").removeClass("field_with_errors")
    $("#resource_error").remove()
  },

  inviteAll: function() {
    $(".invite-resource-btn").each(function() { $(this).trigger( "click" ) })
  },

  showSelectAlls: function ()
  {
    admin.showSelectAll(".invite-resource-btn", ".select-all-resources")
    if ($("#event_eventable_type").val() == "Phase") {
      admin.showSelectAll('#resources tr:not(.invited) label:contains("Reservation")',".select-all-res",".res-info")
      admin.showSelectAll('#resources tr:not(.invited) label:contains("Completed")',".select-all-comp",".comp-info")
    }
  },

  showSelectAll: function (selector, button, info)
  {
    if ($(selector).length == 0) {
      $(button).hide(); $(info).hide()
    } else {
      $(button).show(); $(info).show()
    }
  },

  capitalize: function(name){
    if (name == null ) { return "" }
    return name.charAt(0).toUpperCase() + name.slice(1)
  }
}

// check checkbox on click invite button
$(document).on('click', '.select-all-resources', function(event) {
  event.preventDefault()
  admin.inviteAll()
})

$(document).on('click', '.clear-all-resources', function(event) {
  event.preventDefault()
  $(".uninvite-resource-btn").each(function() { $(this).trigger( "click" ) })
})


// check checkbox on uninvited Reservations
$(document).on('click', '.select-all-res', function(event) {
  event.preventDefault()
  $('#resources tr:not(.invited) label:contains("Reservation")').each(function(row) {
    $(this).closest('tr').find('.invite-resource-btn').trigger('click')
  })
})

// check checkbox on uninvited Completed
$(document).on('click', '.select-all-comp', function(event) {
  event.preventDefault()
  $('#resources tr:not(.invited) label:contains("Complete")').each(function(row) {
    $(this).closest('tr').find('.invite-resource-btn').trigger('click')
  })
})

// check checkbox on click invite button
$(document).on('click', '.invite-resource-btn', function(event) {
  event.preventDefault()
  $(this).closest('tr').find("input[type='checkbox']").trigger('click')
  $(this).addClass('uninvite-resource-btn').removeClass('invite-resource-btn').text("Remove")
  admin.showSelectAlls()
})

// uncheck checkbox on click uninvite button
$(document).on('click', '.uninvite-resource-btn', function(event) {
  event.preventDefault()
  $(this).closest('tr').find("input[type='checkbox']").trigger('click')
  $(this).addClass('invite-resource-btn').removeClass('uninvite-resource-btn').text("Invite")
  admin.showSelectAlls()
})

// prevent checkbox being checked when clicking resident name (checkbox label)
$(document).on('click', '.resident-label label', function(event) {
  event.preventDefault()
})

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

$(document).on('keydown', function(event) {
       if (event.key == "Escape") {
          $(".close_event_dialog").trigger('click')
       }
});
