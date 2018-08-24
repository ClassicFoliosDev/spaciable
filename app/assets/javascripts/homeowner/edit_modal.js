/* global $body */

(function (document, $) {
  'use strict'

  $(document).on('click', '.edit-modal', function (event) {
    var dataIn = $(this).data()

    var $dialogContainer = $('<div>', { id: 'dialog' })
    $dialogContainer.html('<form name="private-document">' +
          '<input type="text" name="title" class="private-document-title" value="' + dataIn.name + '">' +
          '</form>')

    $body.append($dialogContainer)
    var $titleInput = $dialogContainer.find('.private-document-title')

    $dialogContainer.dialog({
      show: 'show',
      modal: true,
      dialogClass: 'archive-dialog edit-dialog',
      title: dataIn.title,
      buttons: [
        {
          text: dataIn.cancel,
          class: 'branded-btn',
          click: function () {
            $(this).dialog('close')
            $(this).dialog('destroy').remove()
          }
        },
        {
          text: dataIn.cta,
          class: 'btn-update branded-btn',
          id: 'btn_submit',
          click: function () {
            /* Not using forms, so update the document name in the page */
            var documentId = dataIn.url.split('/homeowners/private_documents/')[1]
            var dataPath = "[data-document='" + documentId + "']"
            var $privateDocument = $(dataPath)
            $privateDocument.find('h5')[0].innerHTML = $titleInput[0].value

            $(this).dialog('close')
            $(this).dialog('destroy').remove()

            $.ajax({
              url: dataIn.url,
              data: {private_document: {title: $titleInput[0].value}},
              type: 'PUT'
            })
          }
        }]
    }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
  })
})(document, window.jQuery)
