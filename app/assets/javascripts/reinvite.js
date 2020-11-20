/* global $ */
var $body = $('body')

$(document).on('click', '.reinvite-btn', function (event) {
  var dataIn = $(this).data()
  // Note: _ in data content names is translated to camelCase automatically

  var $dialogContainer = $('<div>', { id: 'dialog' }).html('<p>' + dataIn.text + '</p><h3>' + dataIn.name + '</h3>')

  var $details = $('<p>').html(dataIn.details)
  $dialogContainer.append($details)

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
        text: dataIn.cta,
        class: 'btn-send',
        click: function () {
          $(this).dialog('close')
          $(this).dialog('destroy').remove()
          $.post({
            url: dataIn.url,
            dataType: 'json',
            success: function (response) {
              flash_notice(response["message"])
            }
          })
        }
      }]
  }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
})
