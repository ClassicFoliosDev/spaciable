/* global $ */
var $body = $('body')

$(document).on('click', '.info-btn', function (event) {
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
      }]
  }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
  event.stopPropagation();
})

$(document).on('click', '.help-btn', function (event) {
  var dataIn = $(this).data()
  // Note: _ in data content names is translated to camelCase automatically

  var $dialogContainer = $('<div>', { id: 'dialog' }).html('<p>' + dataIn.text + '</p><h3>' + dataIn.name + '</h3>')

  var $details = $('<p>').html(dataIn.details)
  $dialogContainer.append($details)

  $body.append($dialogContainer)

  $dialogContainer.dialog({
    show: 'show',
    modal: true,
    title: dataIn.title,
    width: dataIn.width,
    height: dataIn.height,
    buttons: [
      {
        text: dataIn.cancel,
        class: 'btn-cancel',
        click: function () {
          $(this).dialog('close')
          $(this).dialog('destroy').remove()
        }
      }]
  }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
  event.stopPropagation();
})

function infoDialog (title, message, details) {
  var $dialogContainer = $('<div>', { id: 'dialog' }).html('<p>' + message + '</p>')

  var $details = $('<p>').html(details)
  $dialogContainer.append($details)

  $body.append($dialogContainer)

  $dialogContainer.dialog({
    show: 'show',
    modal: true,
    dialogClass: 'archive-dialog',
    title: title,
    buttons: [
      {
        text: "Cancel",
        class: 'btn-cancel',
        click: function () {
          $(this).dialog('close')
          $(this).dialog('destroy').remove()
        }
      }]
  }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
}
