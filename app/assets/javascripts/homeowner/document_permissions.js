(function (document, $) {
  'use strict'

  /* Trigger the sharing dialog on page load */
  document.addEventListener('turbolinks:load', function (event) {
    if (event.data.url.endsWith('/library/my_home') || event.data.url.endsWith('/private_documents')) {
      showSharingDialog()
    }
  })

  /**
    Modal to inform the resident about document permission sharing options.
    Resident has option to click "don't show this again", otherwise we show it
    every time the library page is loaded
  */
  function showSharingDialog () {
    var cookies = document.cookie
    var index = cookies.indexOf('sharing_info')
    var sharingCookie = cookies.substring(index, 17)

    if (index === -1) {
      document.cookie = 'sharing_info=show'
      sharingCookie = 'sharing_info=show'
    }

    var $sharingDialog = $('.sharing-info')

    if (sharingCookie === ('sharing_info=show') && $sharingDialog.length > 0) {
      var $footer = $('.sharing-footer')

      $sharingDialog.dialog({
        width: 500,
        title: $sharingDialog.data().title,
        dialogClass: 'sharing-info-dialog',
        create: function () {
          $footer.show()
          $('.sharing-info-dialog').append($footer)
        },
        buttons: [
          {
            text: $sharingDialog.data().cta,
            class: 'dialog-btn',
            click: function () {
              $(this).dialog('close')
            }
          }
        ]
      })
    }
  }

  /* Button to turn of the sharing modal permanently */
  $(document).on('click', '.hide-sharing-info', function (event) {
    document.cookie = 'sharing_info=hide'
    var $sharingDialog = $('.sharing-info')
    $sharingDialog.dialog('close')
    $sharingDialog.dialog('destroy').remove()
  })

  /* Toggle the sharing on scoped or private documents when a homeowner resident selects the share circle */
  $(document).on('click', '.document-permission', function (event) {
    var $document = $(this).closest('.document')
    var urlBase = '/homeowners/library/'
    var data = {}
    if ($document.length < 1) {
      urlBase = '/homeowners/private_documents/'
      $document = $(this).closest('.private-document')
      data = {private_document: {enable_tenant_read: 'toggle'}}
    }
    var documentId = $document.data().document
    $(this).toggleClass('shared')

    $.ajax({
      url: urlBase + documentId,
      data: data,
      type: 'PUT',
      documentCircle: $(this),

      success: function (response) {
        var $flash = $('.flash')
        $flash.empty()

        var $notice = document.createElement('p')
        $notice.className = 'notice'
        $notice.innerHTML = response.notice
        $flash.append($notice)
      }
    })
  })
})(document, window.jQuery)
