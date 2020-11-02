/* global $, clearFields, setFields */

document.addEventListener('turbolinks:load', function () {
  var $roleSelect = $('.user_role select, change')
  if ($roleSelect.length == 0) { return }

  var $developerSelect = $('.user_developer_id select')
  var $divisionSelect = $('.user_division_id select')
  var $developmentSelect = $('.user_development_id select')
  var $user_role = $('#cas').attr('data-userrole')

  $roleSelect.selectmenu({
    create: function (event, ui) {
      var $selectInput = $(event.target)
      var role = $selectInput.find('option:selected').attr('value')

      showRoleResourcesOnly(role)
    },
    select: function (event, ui) {
      var role = ui.item.value

      showRoleResourcesOnly(role)

      setCas()
    }
  })

  showRoleResourcesOnly ($('#user_role').val())

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

        setCasEnabledFromDeveloper(developerId)
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
      $('.user_developer_id, .user_division_id, .user_development_id, .receive_release_emails, .cc-receive_release_emails, \
         .receive_choice_emails, .cc-choice-emails, .snag_notifications, .cc-snag_notifications, \
         .receive_invitation_emails, .cc-receive_invitation_emails, .client_specifications, .receive_faq_emails, .cc-receive_faq_emails').hide()
      $("#plot_check").prop("checked", true);
      $("#choice_check").prop("checked", true);
      $("#snag_check").prop("checked", true)
    } else if (role === 'developer_admin') {
      $('.user_developer_id, .receive_release_emails, .cc-receive_release_emails, .snag_notifications, .cc-snag_notifications, \
         .receive_faq_emails, .cc-receive_faq_emails, .receive_invitation_emails, .cc-receive_invitation_emails').show()
      $('.user_division_id, .user_development_id, .administer_lettings').hide()
    } else if (role === 'division_admin') {
      $('.user_developer_id, .user_division_id, .receive_release_emails, .cc-receive_release_emails, .receive_choice_emails, .cc-choice-emails, \
         .snag_notifications, .cc-snag_notifications, .receive_faq_emails, .cc-receive_faq_emails, .receive_invitation_emails, .cc-receive_invitation_emails').show()
      $('.user_development_id, .administer_lettings').hide()
    } else if (role === 'development_admin') {
      $('.user_developer_id, .user_division_id, .user_development_id, .receive_release_emails, .cc-receive_release_emails, .receive_choice_emails, .cc-choice-emails, \
         .administer_lettings, .receive_faq_emails, .cc-receive_faq_emails, .receive_invitation_emails, .cc-receive_invitation_emails, .snag_notifications, .cc-snag_notifications').show()
    } else if (role === 'site_admin') {
      $('.user_developer_id, .user_division_id, .user_development_id, .receive_release_emails, .cc-receive_release_emails, .receive_choice_emails, .cc-choice-emails, \
         .receive_faq_emails, .cc-receive_faq_emails, .receive_invitation_emails, .cc-receive_invitation_emails').show()
      $('.snag_notifications, .cc-snag_notifications, .administer_lettings').hide()
    } else {
      $('.user_developer_id, .user_division_id, .user_development_id').hide()
    };

    setCcLabels()
  };

  // Get the CAS enablement from the developer and display the CAS enablement
  // if necessary
  function setCasEnabledFromDeveloper(developer)
  {
    // development_admins must not be able to see/set CAS
    if ($user_role != "development_admin") {
      $.getJSON({
      url: '/developers/' + developer+ '/cas',
      data: {}
      }).done(function (results) {
        cas = results['cas']
        if (results['cas']) {
          $('.client_specifications').show()
        }
        else {
          $('.client_specifications').hide()
        }
      })
    }
  };

  function setCas()
  {
    // development_admins must not be able to set CAS - it should just
    // maintain it's set state
    if ($user_role != "development_admin") {
      role = $('.user_role select').find('option:selected').attr('value')
      // CAS is always true for developer/division admin and cannot be edited,
      // otherwise false and can be edited
      dev_div_admin = (role === 'developer_admin' || role === 'division_admin')
      $("#cas_check").prop("checked", dev_div_admin)
      $("#cas_check").prop("disabled", dev_div_admin)
    }
  };

  function setCcLabels() {
    $(".cc-email-fields .user_cc_emails_email_type input").each(function() {
      var emailType = $(this)[0].value
      if(!emailType) { return }
      var emailTitle = $("." + emailType + " label")[0].innerText

      $(this).parent().parent($(".cc-email-fields")).addClass("cc-" + emailType)
      $(this).parent().parent().find(".user_cc_emails_email_list label")[0].innerText = "CC " + emailTitle
      $(this).parent().parent().find(".user_cc_emails_email_list textarea").attr("placeholder", "Add any CC email addresses for " + emailTitle + ". Separate multiple email addresses with a space, comma or semi-colon.")
    })
  };
})

// send the positive feedback on positive response
$(document).on('click', '#resendInvitation', function (event) {
  var dataIn = $(this).data()
  var data = { user: dataIn.invite, invitee: dataIn.invitee }

  var $invitationContainer = $('<div>', { class: 'resend-invitation-confirm' })
  .html(
    '<div>' +
      '<p>' +
        'Are you sure you want to send another Spaciable Admin invitation to ' + dataIn.email + '?' +
      '</p>' +
    '</div>'
  )

  $('body').append($invitationContainer)

  $invitationContainer.dialog({
    show: 'show',
    modal: true,
    width: 600,
    title: "Send Invitation",

    buttons: [
      {
        text: "Back",
        class: 'btn',
        click: function () {
          $(this).dialog('destroy')
          $(".resend-invitation-confirm").hide()
        }
      },
      {
        text: "Send",
        class: 'btn',
        click: function () {
          $(this).dialog('destroy')
          $(".resend-invitation-confirm").hide()

          $.getJSON({
            url: '/resend_invitation',
            data: data
          }).done(function () {
            buildNotice('notice', dataIn.email)
          }).fail(function () {
            buildNotice('alert', dataIn.email)
          })
        }
      }]
  }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
})

function buildNotice(status, email) {
  flash_clear()
  if (status == 'notice') {
    flash_notice("An invitation has been sent to " + email)
  } else {
    flash_alert("Failed to send invitation to " + email + ", please try again later.")
  }
}
      
$(document).on('click', '.admin-filter .collapse .fa', function () {
  $(".admin-filter").hide()
  $(".admin-filter-selections").show()

  displayFilterSelections()
})

$(document).on('click', '.admin-filter-selections .collapse .fa', function () {
  $(".admin-filter").show()
  $(".admin-filter-selections").hide()
})

function displayFilterSelections() {
  if ($("#user_search_developer_id").val()) {
    $(".filter-selections").html(
      "<label>Developer: </label> <span>" + $("#user_search_developer_id-button")[0].innerText + "</span><br/>" +
      "<label>Division: </label> <span>" + $("#user_search_division_id-button")[0].innerText + "</span><br/>" +
      "<label>Development: </label> <span>" +$("#user_search_development_id-button")[0].innerText + "</span><br/>" +
      "<label>Role: </label> <span>" + $("#user_search_role-button")[0].innerText + "</span>"
    )
  } else {
    $(".filter-selections").html(
      "<label>Developer: </label><span>" + $("#user_search_developer_id-button")[0].innerText + "</span><br/>" +
      "<label>Role: </label> <span>" + $("#user_search_role-button")[0].innerText + "</span>"
    )
  }
}
