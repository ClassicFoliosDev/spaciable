/* global $ */

// Handle a .cancel-btn click and display a confirmation
// dialog.  Confirm replaces the current page with the
// contents of the supplied url
var $body = $('body')

$(document).on('click', '.cancel-btn', function (event) {
  var dataIn = $(this).data()

  var $dialogContainer = $('<div>', { id: 'dialog' }).html(
                           '<p>' + dataIn.text + '</p>')

  $body.append($dialogContainer)

  $dialogContainer.dialog({
    show: 'show',
    modal: true,
    dialogClass: 'archive-dialog',
    title: dataIn.title,
    buttons: [
      {
        text: dataIn.cancel,
        class: 'btn-cancel',
        click: function () {
          $(this).dialog('close')
          $(this).dialog('destroy').remove()
        }
      },
      {
        // Font awesome trash icon added in SCSS
        text: dataIn.cta,
        class: 'btn-delete',
        id: 'btn_confirm',
        click: function () {
          $('.btn-delete').button('disable')
          $('.btn-cancel').button('disable')

          window.location.replace(dataIn.url)
        }
      }]
  }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
})
