/* global $, clearFields, setFields */

document.addEventListener('turbolinks:load', function () {
  var $roleSelect = $('.user_role select')
  var $developerSelect = $('.user_developer_id select')
  var $divisionSelect = $('.user_division_id select')
  var $developmentSelect = $('.user_development_id select')

  $roleSelect.selectmenu({
    create: function (event, ui) {
      var $selectInput = $(event.target)
      var role = $selectInput.find('option:selected').attr('value')

      showRoleResourcesOnly(role)
    },
    select: function (event, ui) {
      var role = ui.item.value

      showRoleResourcesOnly(role)
    }
  })

  function developerSelectmenuCallbacks () {
    return {
      create: function (event, ui) {
        var $selectInput = $(event.target)
        var developerId = $selectInput.val()

        if (developerId) {
          fetchDeveloperResources(developerId)
          $divisionSelect.selectmenu(divisionSelectmenuCallbacks(developerId))
        } else {
          fetchDeveloperResources()
          $divisionSelect.selectmenu(divisionSelectmenuCallbacks())
        };
      },
      select: function (event, ui) {
        var developerId = ui.item.value

        fetchDivisionResources({ developerId: developerId })
        fetchDevelopmentResources({ developerId: developerId })
      }
    }
  };

  function divisionSelectmenuCallbacks (developerId) {
    return {
      create: function (event, ui) {
        var $selectInput = $(event.target)
        var divisionId = $selectInput.val()

        if (divisionId) {
          fetchDivisionResources({developerId: developerId, divisionId: divisionId})
        } else if (developerId) {
          fetchDivisionResources({ developerId: developerId })
        } else {
          clearFields($('.user_division_id'))
        };

        $developmentSelect.selectmenu(developmentSelectmenuCallbacks(developerId, divisionId))
      },
      select: function (event, ui) {
        var divisionId = ui.item.value

        if (divisionId !== '') {
          fetchDevelopmentResources({divisionId: divisionId})
        } else {
          fetchDevelopmentResources({developerId: $developerSelect.val()})
        };
      }
    }
  };

  function developmentSelectmenuCallbacks (developerId, divisionId) {
    return {
      create: function (event, ui) {
        var $selectInput = $(event.target)
        var developmentId = $selectInput.val()

        if (developmentId) {
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
          clearFields($('.user_development_id'))
        };
      }
    }
  };

  function fetchDeveloperResources (developerId) {
    var developerSelect = clearFields($('.user_developer_id'))
    var url = '/admin/developers'

    setFields(developerSelect, url, {developerId: developerId})
  };

  function fetchDivisionResources (data) {
    var divisionSelect = clearFields($('.user_division_id'))
    var url = '/admin/divisions'

    setFields(divisionSelect, url, data)
  };

  function fetchDevelopmentResources (data) {
    var developmentSelect = clearFields($('.user_development_id'))
    var url = '/admin/developments'

    setFields(developmentSelect, url, data)
  };

  function showRoleResourcesOnly (role) {
    if (role !== 'cf_admin' && role !== '') {
      $developerSelect.selectmenu(developerSelectmenuCallbacks())
    };

    if (role === 'cf_admin') {
      $('.user_developer_id, .user_division_id, .user_development_id').hide()
    } else if (role === 'developer_admin') {
      $('.user_developer_id').show()
      $('.user_division_id, .user_development_id').hide()
    } else if (role === 'division_admin') {
      $('.user_developer_id, .user_division_id').show()
      $('.user_development_id').hide()
    } else if ((role === 'development_admin') || (role === 'site_admin')) {
      $('.user_developer_id, .user_division_id, .user_development_id').show()
    } else {
      $('.user_developer_id, .user_division_id, .user_development_id').hide()
    };
  };
})
