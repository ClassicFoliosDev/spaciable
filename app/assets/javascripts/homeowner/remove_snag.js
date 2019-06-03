/* global alert */

(function (document, $) {
  'use strict'

  $(document).on('click', '.destroy-snag', function (event) {
    var dataIn = $(this).data()

    var $confirmContainer = $('<div>', { id: 'dialog' }).html(dataIn.text + '<p>' + dataIn.details + '</p>')
    $('body').append($confirmContainer)

    $confirmContainer.dialog({
      show: 'show',
      modal: true,
      width: 500,
      title: dataIn.title,
      buttons: [
        {
          text: dataIn.cancel,
          class: 'btn',
          click: function () {
            $(this).dialog('close')
            $(this).dialog('destroy').remove()
          }
        },
        {
          text: dataIn.cta,
          class: 'remove-snag btn',
          id: 'btn_submit',
          click: function () {
            $(this).dialog('close')
            $(this).dialog('destroy').remove()
            // Clear any old messages before the ajax call
            $('.flash').empty()

            $.ajax({
              url: '/homeowners/snags/' + dataIn.snag,
              type: 'DELETE'
            })
          }
        }]
    }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
  })

})(document, window.jQuery)
