(function (document, $) {
  'use strict'

  $(document).on('click', '.confirm-letting-type', function (event) {
    var dataIn = $(this).data()

    var $confirmContainer = $('<div>', { id: 'dialog' }).html(dataIn.text + '<p>' + dataIn.details + '</p>')
    $confirmContainer.append($('.lettings-account-form'))

    $('body').append($confirmContainer)
    var $form = $('.new_lettings_account')

    $confirmContainer.dialog({
      show: 'show',
      modal: true,
      width: 700,
      title: dataIn.title,
      buttons: [
        {
          text: dataIn.cancel,
          class: 'btn',
          click: function () {
            $(this).dialog('destroy')
          }
        },
        {
          text: dataIn.cta,
          class: 'btn-send btn',
          id: 'btn_submit',
          click: function () {
            $(this).dialog('destroy')
            $confirmContainer.hide()

            $.post({
              url: dataIn.url,
              data: $form.serialize(),
              dataType: 'json',
              success: function (response) {
                window.location=response
              }
            })


          }
        }]
    }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
    document.getElementById('lettings_account_management').value = dataIn.type
  })

})(document, window.jQuery)
