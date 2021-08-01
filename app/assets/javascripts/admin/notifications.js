/* global $, clearFields, setFields */

document.addEventListener('turbolinks:load', function () {
  (function () {
    var $developerSelect = $('.notification_developer_id select')

    if ($developerSelect.length === 0) {
      $developerSelect = $('.report_developer_id select')
    }

    if ($developerSelect.length > 0) {
      $developerSelect.selectmenu(developerSelectmenuCallbacks())
    }
  })(
    initialiseDeveloper()
  )

  function developerSelectmenuCallbacks () {
    return {
      create: function (event, ui) {
        var $selectInput = $(event.target)
        var developerId = $selectInput.val()

        if (developerId) {
          var $divisionSelect = $('.notification_division_id select')
          fetchDeveloperResources({ developerId: developerId })
          $divisionSelect.selectmenu(divisionSelectmenuCallbacks(developerId))
        }
      },
      select: function (event, ui) {
        var developerId = ui.item.value

        if (developerId !== '') {
          fetchDivisionResources({ developerId: developerId })
          fetchDevelopmentResources({ developerId: developerId })
          fetchPhaseResources({ developerId: developerId })
        } else {
          fetchDivisionResources()
          fetchDevelopmentResources()
          fetchPhaseResources()
        }
      }
    }
  };

  function divisionSelectmenuCallbacks (developerId) {
    return {
      create: function (event, ui) {
        var $selectInput = $(event.target)
        var divisionId = $selectInput.val()
        var $developmentSelect = $('.notification_development_id select')
        if ($developmentSelect.length === 0) {
          $developmentSelect = $('.report_development_id select')
        }
        var $phaseSelect = $('.notification_phase_id select')

        if (divisionId !== '') {
          fetchDivisionResources({developerId: developerId, divisionId: divisionId})
          $developmentSelect.selectmenu(developmentSelectmenuCallbacks(developerId, divisionId))
          if ($phaseSelect.length > 0) {
            $phaseSelect.selectmenu(phaseSelectmenuCallbacks(developerId, divisionId))
          }
        } else if (divisionId === '') {
          fetchDivisionResources({ developerId: developerId })
          $developmentSelect.selectmenu(developmentSelectmenuCallbacks(developerId))
          if ($phaseSelect.length > 0) {
            $phaseSelect.selectmenu(phaseSelectmenuCallbacks(developerId))
          }
        };
      },
      select: function (event, ui) {
        var divisionId = ui.item.value

        if (divisionId) {
          fetchDevelopmentResources({ divisionId: divisionId })
          fetchPhaseResources({ divisionId: divisionId })
        } else {
          var $developerSelect = $('.notification_developer_id select')

          if ($developerSelect.length === 0) {
            $developerSelect = $('.report_developer_id select')
          }
          var developerId = $developerSelect.val()
          if (developerId) {
            fetchDevelopmentResources({ developerId: developerId })
            fetchPhaseResources({ developerId: developerId })
          }
        };
      }
    }
  };

  function developmentSelectmenuCallbacks (developerId, divisionId) {
    return {
      create: function (event, ui) {
        var $selectInput = $(event.target)
        var developmentId = $selectInput.val()

        if (developmentId !== '') {
          fetchDevelopmentResources({
            developerId: developerId,
            divisionId: divisionId,
            developmentId: developmentId
          })
        } else if (divisionId) {
          fetchDevelopmentResources({
            developerId: developerId,
            divisionId: divisionId
          })
        } else {
          fetchDevelopmentResources({
            developerId: developerId
          })
        };
      },
      select: function (event, ui) {
        var developmentId = ui.item.value

        if (developmentId !== '') {
          fetchPhaseResources({ developmentId: developmentId })
        };
      }
    }
  };

  function phaseSelectmenuCallbacks (developerId, divisionId, developmentId) {
    return {
      create: function (event, ui) {
        var $selectInput = $(event.target)
        var phaseId = $selectInput.val()

        if (phaseId) {
          fetchPhaseResources({
            developerId: developerId,
            divisionId: divisionId,
            developmentId: developmentId,
            phaseId: phaseId
          })
        } else if (developmentId) {
          fetchPhaseResources({
            developmentId: developmentId
          })
        } else if (divisionId) {
          fetchPhaseResources({
            divisionId: divisionId
          })
        } else {
          fetchPhaseResources({
            developerId: developerId
          })
        };

        HideShowPlotList()
      },
      select: function (event, ui) {
        // Set the hidden field if it is there
        if($('#phase_id')){
          $('#phase_id').val(ui.item.value)
        }

        HideShowPlotList()
      }
    }
  };

  function HideShowPlotList(){
    // Clear out the plots
    if ($("textarea[name='plots_select']")){
        $("textarea[list='selected_plots']").val("");
    }

    if($('#phase_id')[0].value == ""){
      $("#add_plots").hide()
      $(".notification_list").hide()
    }
    else{
      $("#add_plots").show()
      $(".notification_list").show()
    }
  }

  function fetchDivisionResources (data) {
    var $divisionId = $('.notification_division_id')
    if ($divisionId.length === 0) {
      $divisionId = $('.report_division_id')
    }

    var divisionSelect = clearFields($divisionId)
    var url = '/admin/divisions'

    setFields(divisionSelect, url, data)
  };

  function fetchDevelopmentResources (data) {
    var $developmentId = $('.notification_development_id')
    if ($developmentId.length === 0) {
      $developmentId = $('.report_development_id')
    }

    var developmentSelect = clearFields($developmentId)
    var url = '/admin/developments'

    setFields(developmentSelect, url, data)
  };

  function fetchPhaseResources (data) {
    var $phaseId = $('.notification_phase_id')
    if ($phaseId.length > 0) {
      var phaseSelect = clearFields($phaseId)
      var url = '/admin/phases'
      setFields(phaseSelect, url, data)
      $('#phase_id').val("")
      HideShowPlotList()
    }
  };

  function initialiseDeveloper () {
    var $developerSelect = $('.notification_developer_id select')
    if ($developerSelect.length === 0) {
      $developerSelect = $('.report_developer_id select')
    }

    if ($developerSelect.length > 0) {
      if ($developerSelect[0].options.length < 2) {
        var $divisionSelect = $('.notification_division_id select')
        if ($divisionSelect.length === 0) {
          $divisionSelect = $('.report_division_id select')
        }

        fetchDeveloperResources()
        $divisionSelect.selectmenu(divisionSelectmenuCallbacks())
      }
    }
  }

  function fetchDeveloperResources (data) {
    var $developerId = $('.notification_developer_id')
    if ($developerId.length === 0) {
      $developerId = $('.report_developer_id')
    }

    var developerSelect = clearFields($developerId)
    var url = '/admin/developers'

    setFields(developerSelect, url, data, data == undefined)
  };
})

$(document).on('click', '#plotNotificationBtn', function (event) {
  var role_filter = $("input[name='notification[send_to_role]']:checked").val()
  var plot_filter = $("input[name='notification[plot_filter]']:checked").val()
  var developer_id = $("#notification_developer_id").val()
  var division_id = $("#notification_division_id").val()
  var development_id = $("#notification_development_id").val()
  var phase_id = $("#notification_phase_id").val()
  var plot_numbers = $("#notification_list")[0].value

  $.getJSON({
    url: '/admin/qualifing_plots',
    data: { 'role_filter' : $("input[name='notification[send_to_role]']:checked").val(),
            'plot_filter' : $("input[name='notification[plot_filter]']:checked").val(),
            'developer_id' : $("#notification_developer_id").val(),
            'division_id' : $("#notification_division_id").val(),
            'development_id' : $("#notification_development_id").val(),
            'phase_id' : $("#notification_phase_id").val(),
            'plot_numbers' : $("#notification_list")[0].value
          }
  }).done(function (results) {
    confirm_notification(results)
  })

})

function confirm_notification (results){
  var confirm = true

  var form = $(".new_notification")
  var dataIn = $("#plotNotificationBtn").data()

  var developer = $("#notification_developer_id-button .ui-selectmenu-text").text()
  var division = $("#notification_division_id-button .ui-selectmenu-text").text()
  var development = $("#notification_development_id-button .ui-selectmenu-text").text()
  var phase = $("#notification_phase_id-button .ui-selectmenu-text").text()
  var plots = $("#notification_list")[0].value

  if($("#notification_developer_id")[0].value == 0) {
    var $dialogContainer = $('<div>', { class: 'confirm-send-all' }).html('<p>' + dataIn.all + '</p>')
  } else {

    var title = "Confirm Send"
    var plots_type = "Selected Plots: "
    var message = ""
    var plots = $("#notification_list")[0].value
    var requested_plots = $("#notification_list")[0].value.split(',')

    if (results["qualifing_plots"].length == 0) {
      message = dataIn.noplots
      title = "Review Selections"
      confirm = false
    } else if ($("#notification_list")[0].textLength > 0) {
      if (results["qualifing_plots"].length < results["requested_plots"].length) {
        message = dataIn.filtered
        plots = results["qualifing_plots"].join()
        plots_type = "Qualifing Plots: "
      }
    } else {
      message = dataIn.warning
    }

    var $dialogContainer = $('<div>', { class: 'confirm-no-plots' })

    if(message.length > 0) {
      $dialogContainer.append('<p>' + message + '</p>')
    }

    $dialogContainer.append('<p><span>' + 'Developer: ' + '</span>' + developer + '</p>')

    if($("#notification_division_id")[0].value > 0) {
      $dialogContainer.append('<p><span>' + 'Division: ' + '</span>' + division + '</p>')
    }
    if($("#notification_development_id")[0].value > 0) {
      $dialogContainer.append('<p><span>' + 'Development: ' + '</span>' + development + '</p>')
    }
    if($("#notification_phase_id")[0].value > 0) {
      $dialogContainer.append('<p><span>' + 'Phase: ' + '</span>' + phase + '</p>')
    }
        
    $dialogContainer.append('<p><span>' + 'Resident Filter: ' + '</span>' + $("input[name='notification[send_to_role]']:checked").next().text() + '</p>')
    $dialogContainer.append('<p><span>' + 'Plot Filter: ' + '</span>' + $("input[name='notification[plot_filter]']:checked").next().text() + '</p>')

    if(plots.length > 0) {
      $dialogContainer.append('<p><span>' + plots_type + plots + '</p>')
    } else if ($("#notification_developer_id")[0].value != 0) {
      $dialogContainer.append('<p><span>All Plots</p>')
    }
  }

  $body.append($dialogContainer)

  $dialogContainer.dialog({
    show: 'show',
    modal: true,
    dialogClass: 'submit-dialog',
    title: title,
    buttons: [
      {
        text: "Cancel",
        class: 'btn-cancel',
        click: function () {
          $(this).dialog('close')
          $(this).dialog('destroy').remove()
        }
      },
      {
        text: "Confirm",
        class: 'btn-confirm',
        id: 'btn_confirm',
        click: function () {
          $('.btn-confirm').button('disable')
          $('.btn-cancel').button('disable')
          form.submit(); // Form submission
        }
      }]
  }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button

  $("#btn_confirm").toggle(confirm)
}
