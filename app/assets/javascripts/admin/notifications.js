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
      }
    }
  };

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

    setFields(developerSelect, url, data)
  };
})
