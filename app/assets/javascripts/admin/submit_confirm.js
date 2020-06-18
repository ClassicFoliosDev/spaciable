/* global $ */
var $body = $('body')

// displays confirm dialog and submits to the 'form' parent
// of the event host
$(document).on('click', '.btn-form-submit-confirm', function (event) {
  event.preventDefault()
  var form = $(this).closest('form')
  var dataIn = $(this).data()
  var $dialogContainer = $('<div>', { id: 'dialog' }).html('<p>' + dataIn.text + '</p>')

  $body.append($dialogContainer)

  $dialogContainer.dialog({
    show: 'show',
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
