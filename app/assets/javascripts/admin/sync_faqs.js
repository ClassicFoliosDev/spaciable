// select all checkboxes in the specified category, excluding disabled ones
$(document).on('click', '.category-select-all', function (event) {
  var category = $(this).data().category
  $(".faq_" + category).each(function() {
    var faq = ($(this).find("input"))
    faq.each(function () {
      if (!faq[0].disabled) {
        faq[0].checked = true
      }
    })
  })
})

// deselect all checkboxes in the specified category
$(document).on('click', '.category-deselect-all', function (event) {
  var category = $(this).data().category
  $(".faq_" + category).each(function() {
    var faq = ($(this).find("input"))
    faq.each(function () {
      faq[0].checked = false
    })
  })
})

// select all checkboxes on form, excluding disabled ones
$(document).on('click', '.select-all', function (event) {
  $(".faq-selector").each(function() {
    var faq = ($(this).find("input"))
    faq.each(function () {
      if (!faq[0].disabled) {
        faq[0].checked = true
      }
    })
  })
})

// deselect all checkboxes on form
$(document).on('click', '.deselect-all', function (event) {
  $(".faq-selector").each(function() {
    var faq = ($(this).find("input"))
    faq.each(function () {
      faq[0].checked = false
    })
  })
})

// show the faq answer comparison div
$(document).on('click', '.compare-btn', function (event) {
  event.preventDefault()
  var faq = $(this).data().id
  $(".faq_compare_" + faq).show()
  $(".compare_" + faq).hide()
  $(".hide_" + faq).show()
})

// hide the faq answer comparison div
$(document).on('click', '.hide-btn', function (event) {
  event.preventDefault()
  var faq = $(this).data().id
  $(".faq_compare_" + faq).hide()
  $(".hide_" + faq).hide()
  $(".compare_" + faq).show()
})

// check submit button status on checkbox click
$(document).on('change', '.faq-collection input', function () {
  enableDisableSubmit()
})

// check submit button status on button click
$(document).on('click', '.faq-sync .btn, .sync-faqs-select-buttons .btn', function () {
  enableDisableSubmit()
})

// enable the submit button if at least one checkbox is selected
// if no checkboxes are selected then disable the submit button
function enableDisableSubmit() {
  $(".sync-faqs-btn")[0].disabled = true
  $(".faq-selector input").each(function() {
    if (this.checked) {
      $(".sync-faqs-btn")[0].disabled = false
      return false
    }
  })
}

$(document).on('click', '.sync-faqs-btn', function (event) {
  event.preventDefault()
  var form = $(this).closest('form')
  var dataIn = $(this).data()
  var text = syncConfirmText(dataIn.parent)
  var $dialogContainer = $('<div>', { id: 'dialog' }).html('<p>' + text + '</p>')

  $body.append($dialogContainer)

  $dialogContainer.dialog({
    show: 'show',
    width: '500px',
    modal: true,
    dialogClass: 'submit-dialog',
    title: dataIn.header,
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
})

function syncConfirmText(parent) {
  var create = $(".no_match input:checked").length
  var update = $(".answer_legacy input:checked").length + $(".answer_updated input:checked").length

  return "Are you sure you want to create " + create + " and update " + update + " " + parent + " FAQs?"
}


document.addEventListener('turbolinks:load', function () {
  if( $(".info_answer_updated").length ) {
    $(".info_answer_updated").attr("title", "Local FAQ has been updated/modified since creation. Select this FAQ to overwrite local answer with global answer.")
  }
  if( $(".info_no_match").length ) {
    $(".info_no_match").attr("title", "No local match. Select this FAQ to import it (creates new local FAQ).")
  }
  if( $(".info_answer_legacy").length ) {
    $(".info_answer_legacy").attr("title", "Local FAQ has never been updated. Select this FAQ to overwrite local answer with global answer.")
  }
})
