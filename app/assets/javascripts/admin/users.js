/* global $, clearFields, setFields */
var $num_additional_roles = 0

document.addEventListener('turbolinks:load', function () {
  $num_additional_roles = $('.additional-role').length
  var $primary = ""
  var $su = "_su"
  var $roleSelect = $('.user_role select, change')
  if ($roleSelect.length == 0) { return }

  var $developer = "developer"
  var $division = "division"
  var $development = "development"
  //var $developerSelect = $('.user_developer_id select')
  //var $divisionSelect = $('.user_division_id select')
  //var $developmentSelect = $('.user_development_id select')
  var $user_role = $('#cas').attr('data-userrole')

  const prefixes = [$primary, $su]
  prefixes.forEach(function (prefix, index) {
     $('.user' + prefix + '_role select, change').selectmenu({
      create: function (event, ui) {
        var $selectInput = $(event.target)
        var role = $selectInput.find('option:selected').attr('value')
        if (prefix == $su) { $selectInput.find("option[value='cf_admin']").remove() }

        showRoleResourcesOnly(role, prefix == $primary)
      },
      select: function (event, ui) {
        var role = ui.item.value

        showRoleResourcesOnly(role, ui.item.element[0].parentElement.id == "user_role")

        setCas()
      }
    })
  })

  showRoleResourcesOnly ($('#user_role').val(), true)

  function developerSelectmenuCallbacks (primary) {
    return {
      create: function (event, ui) {
        var $selectInput = $(event.target)
        var developerId = $selectInput.val()

        if (developerId) {
          fetchDeveloperResources(developerId, primary)
          getSelector($division, primary).selectmenu(divisionSelectmenuCallbacks(developerId, primary))
        } else {
          fetchDeveloperResources(0, primary)
          getSelector($division, primary).selectmenu(divisionSelectmenuCallbacks(0, primary))
        };
      },
      select: function (event, ui) {
        var developerId = ui.item.value

        fetchDivisionResources({ developerId: developerId }, primary)
        fetchDevelopmentResources({ developerId: developerId }, primary)

        if (primary) { setCasEnabledFromDeveloper(developerId) }
      }
    }
  };

  function divisionSelectmenuCallbacks (developerId, primary) {
    return {
      create: function (event, ui) {
        var $selectInput = $(event.target)
        var divisionId = $selectInput.val()

        if (divisionId) {
          fetchDivisionResources({developerId: developerId, divisionId: divisionId}, primary)
        } else if (developerId) {
          fetchDivisionResources({ developerId: developerId }, primary)
        } else {
          clearFields($('.user' + (primary ? $primary : $su) + '_division_id'))
        };

        getSelector($development, primary).selectmenu(developmentSelectmenuCallbacks(developerId, divisionId, primary))
      },
      select: function (event, ui) {
        var divisionId = ui.item.value

        if (divisionId !== '') {
          fetchDevelopmentResources({divisionId: divisionId}, primary)
        } else {
          fetchDevelopmentResources({developerId: getSelector($developer, primary).val()}, primary)
        };
      }
    }
  };

  function developmentSelectmenuCallbacks (developerId, divisionId, primary) {
    return {
      create: function (event, ui) {
        var $selectInput = $(event.target)
        var developmentId = $selectInput.val()

        if (developmentId) {
          fetchDevelopmentResources({
            developerId: developerId,
            divisionId: divisionId,
            developmentId: developmentId,
          }, primary)
        } else if (divisionId) {
          fetchDevelopmentResources({
            developerId: developerId,
            divisionId: divisionId
          }, primary)
        } else {
          clearFields($('.user' + (primary ? $primary : $su) + '_development_id'))
          setAdditionalState()
        };
      },
      select: function (event, ui) {
        setAdditionalState()
      }
    }
  };

  function fetchDeveloperResources (developerId, primary) {
    var developerSelect = clearFields($('.user' + (primary ? $primary : $su) + '_developer_id'))
    var url = '/admin/developers'

    setFields(developerSelect, url, {developerId: developerId}, true, setAdditionalState)
  };

  function fetchDivisionResources (data, primary) {
    var divisionSelect = clearFields($('.user' + (primary ? $primary : $su) + '_division_id'))
    var url = '/admin/divisions'

    setFields(divisionSelect, url, data, true, setAdditionalState)
  };

  function fetchDevelopmentResources (data, primary) {
    var developmentSelect = clearFields($('.user' + (primary ? $primary : $su) + '_development_id'))
    var url = '/admin/developments'

    setFields(developmentSelect, url, data, true, setAdditionalState)
  };

  function showRoleResourcesOnly (role, primary) {
    if (role !== 'cf_admin' && role !== '') {
      getSelector($developer, primary).selectmenu(developerSelectmenuCallbacks(primary))
    };

    if (role === 'cf_admin') {
      if (primary) {
        $('.user_developer_id, .user_division_id, .user_development_id, .receive_release_emails, .cc-receive_release_emails, \
           .receive_choice_emails, .cc-choice-emails, .snag_notifications, .cc-snag_notifications, \
           .receive_invitation_emails, .cc-receive_invitation_emails, .client_specifications, .receive_faq_emails, .cc-receive_faq_emails').hide()
        $("#plot_check").prop("checked", true);
        $("#choice_check").prop("checked", true);
        $("#snag_check").prop("checked", true)
      } else {
        $('.user_su_developer_id, .user_su_division_id, .user_su_ development_id').hide()
      }
    } else if (role === 'developer_admin') {
      if (primary) {
        $('.user_developer_id, .receive_release_emails, .cc-receive_release_emails, .snag_notifications, .cc-snag_notifications, \
           .receive_faq_emails, .cc-receive_faq_emails, .receive_invitation_emails, .cc-receive_invitation_emails').show()
        $('.user_division_id, .user_development_id, .administer_lettings').hide()
      } else {
        $('.user_su_developer_id').show()
        $('.user_su_division_id, .user_su_development_id').hide()
      }
    } else if (role === 'division_admin') {
      if (primary) {
        $('.user_developer_id, .user_division_id, .receive_release_emails, .cc-receive_release_emails, .receive_choice_emails, .cc-choice-emails, \
           .snag_notifications, .cc-snag_notifications, .receive_faq_emails, .cc-receive_faq_emails, .receive_invitation_emails, .cc-receive_invitation_emails').show()
        $('.user_development_id, .administer_lettings').hide()
      } else {
        $('.user_su_developer_id, .user_su_division_id').show()
        $('.user_su_development_id').hide()
      }
    } else if (role === 'development_admin') {
      if (primary) {
        $('.user_developer_id, .user_division_id, .user_development_id, .receive_release_emails, .cc-receive_release_emails, .receive_choice_emails, .cc-choice-emails, \
           .administer_lettings, .receive_faq_emails, .cc-receive_faq_emails, .receive_invitation_emails, .cc-receive_invitation_emails, .snag_notifications, .cc-snag_notifications').show()
      } else {
        $('.user_su_developer_id, .user_su_division_id, .user_su_development_id').show()
      }
    } else if (role === 'site_admin') {
      if (primary) {
        $('.user_developer_id, .user_division_id, .user_development_id, .receive_release_emails, .cc-receive_release_emails, .receive_choice_emails, .cc-choice-emails, \
           .receive_faq_emails, .cc-receive_faq_emails, .receive_invitation_emails, .cc-receive_invitation_emails').show()
        $('.snag_notifications, .cc-snag_notifications, .administer_lettings').hide()
      } else {
        $('.user_su_developer_id, .user_su_division_id, .user_su_development_id').show()
      }
    } else if (role === 'concierge') {
      if (primary) {
        $('.user_developer_id, .user_division_id, .user_development_id').show()
        $('.receive_release_emails, .cc-receive_release_emails, .receive_choice_emails, .cc-choice-emails, \
           .receive_faq_emails, .cc-receive_faq_emails, .receive_invitation_emails, .cc-receive_invitation_emails \
           .snag_notifications, .cc-snag_notifications, .administer_lettings').hide()
      } else {
        $('.user_su_developer_id, .user_su_division_id, .user_su_development_id').show()
      }
    } else {
      if (primary) {
        $('.user_developer_id, .user_division_id, .user_development_id').hide()
      } else {
        $('.user_su_developer_id, .user_su_division_id, .user_su_development_id').hide()
      }
    };

    setAdditionalState()
    setCcLabels()
  };

  function getSelector(type, primary) {
    return $developerSelect = $('.user' + (primary ? $primary : $su) + '_' + type + '_id select')
  }

  function setAdditionalState (){
    primary = userDefined(true)
    additional = userDefined(false)

    $("#add_role").toggle(primary && additional)

    try {
      const selects = ["#user_su_role", "#user_su_developer_id", "#user_su_division_id", "#user_su_development_id"]
      selects.forEach(function (s, index) {
        if (primary && $(s + " option:selected").val() != undefined) {
          $(s).removeAttr('disabled').removeClass('disabled')
          $(s).selectmenu('enable')
        } else {
          $(s).attr('disabled', 'disabled').addClass('disabled')
          $(s).selectmenu('disable')
        }
      })
    }
    catch(err) {
       x = 1
    }
  }

  function userDefined(primary) {
    defined = false

    // set defined according to the last visible select's selection
    $("." + (primary ? "" : "su-") + "permission-level select").each(function() {
      if ($("." + $(this).prop("id")).is(":visible")) {
        defined = !($(this).children("option:selected").val() == "" ||
                    $(this).children("option:selected").val() == undefined)
      }
    })

    return defined
  }


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

$(document).on('click', '#users_export_csv', function (event) {
  $.post({
    url: this.dataset["href"],
    data: $("form").serialize(),
    dataType: 'json',
    success: function (response) {
      reportSubmitted()
    }
  })
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

// Add a new grant into the DOM. Make a copy of the html for the
// first grant on the page.  Grants are streamed as
// arrays e.g. name=user[grants_attributes][0][role] and
// id = user_grants_attributes_0_role.  This function
// clones the first grant and resets all the indices then
// sets the fields.  Finally it prepends itself
$(document).on('click', '#add_role', function (event) {

  additional_role = getAdditionalRole()
  duplicate = duplicateOf(additional_role)

  if (duplicate != null) {
    meta = duplicate.clone().find("#metadata")
    meta.find("i").remove()
    infoDialog("Duplicate Role", "This is a duplicate of an existing role", meta.html())
  } else {
    newrole = $('.additional-role').first().clone()
    $('.additional-role').last().after(newrole)
    newrole.find("#metadata").empty()
    newrole.find("input").each(function() { initialiseRole($(this)) })
    newrole.find("input")[0].value = additional_role.role
    newrole.find("input")[1].value = additional_role.grantable_type
    newrole.find("input")[2].value = additional_role.grantable_id
    newrole.find("input[deletefield='true']").val(false)

    additional_role.meta.forEach(function (text, index) { newrole.find("#metadata").append(text) })

    newrole.show()
    $num_additional_roles += 1
  }
})

function initialiseRole(role){
  const attribs = ["name", "id"]
  attribs.forEach(function(attrib, index){
    var prop = role.prop(attrib);
    if (typeof prop !== typeof undefined && prop !== false) {
      role.prop(attrib, role.prop(attrib).replace(/0/g, $num_additional_roles))
    }
  })
  role.val("")
}

function createRoleHeader(text) {
  return "<div>" +
            "<span class='additional-role-meta inline'>" + text + "</span>" +
            "<i class='fa fa-times delete'></i>" +
          "</div>"
}

function createRoleMetadata(text) {
  return "<span class='additional-role-meta'>" + text + "</span>"
}

$(document).on('click', '.additional-role .delete', function (event) {
  role = $(this).closest('.additional-role')
  meta = role.clone().find("#metadata")
  meta.find("i").remove()
  confirmDelete(meta.html(), role, deleteAdditionalRole)
})

function deleteAdditionalRole(role) {
  role.find("input[deletefield='true']").val(true)
  role.hide()
}

function duplicateOf(additional_role) {
  duplicate = null

  $(".additional-role").each(function() {
    if ($(this).find("input")[0].value == additional_role.role &&
        $(this).find("input")[1].value == additional_role.grantable_type &&
        $(this).find("input")[2].value == additional_role.grantable_id) {
      duplicate = $(this)
    }
  })

  return duplicate
}

function getAdditionalRole()
{
  const selection = {role : $("#user_su_role option:selected").val(),
                     meta: [createRoleHeader($("#user_su_role option:selected").text())] }

  switch(selection.role) {
    case "developer_admin":
      selection.grantable_type = "Developer"
      selection.grantable_id = $("#user_su_developer_id option:selected").val()
      selection.meta.push(createRoleMetadata($("#user_su_developer_id option:selected").text()))
    break;
      break;
    case "division_admin":
      selection.grantable_type = "Division"
      selection.grantable_id = $("#user_su_division_id option:selected").val()
      selection.meta.push(createRoleMetadata($("#user_su_developer_id option:selected").text()))
      selection.meta.push(createRoleMetadata($("#user_su_division_id option:selected").text()))
      break;
    case "development_admin":
    case "site_admin":
      selection.grantable_type = "Development"
      selection.grantable_id = $("#user_su_development_id option:selected").val()
      selection.meta.push(createRoleMetadata($("#user_su_developer_id option:selected").text()))
      if ($("#user_su_division_id option:selected").val() != "" &&
          $("#user_su_division_id option:selected").val() != undefined) {
        selection.meta.push(createRoleMetadata($("#user_su_division_id option:selected").text()))
      }
      selection.meta.push(createRoleMetadata($("#user_su_development_id option:selected").text()))
      break;
    default:
      // code block
    }

  return selection
}





