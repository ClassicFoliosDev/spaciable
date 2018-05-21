(function (document, $) {
  'use strict'

  $(document).on('click', '.destroy-resident', function (event) {
    var dataIn = $(this).data()

    var $deactivateContainer = $('.remove-resident-form')

    $('body').append($deactivateContainer)
    var $form = $('.destroy_resident')

    $deactivateContainer.dialog({
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
          disabled: true,
          click: function () {
            var password = $('.resident-password')[0].value
            $.ajax({
              url: "/homeowners/residents/" + dataIn.resident,
              type: 'DELETE',
              data: { password: password },
              success: function(response) {
                if (response.alert !== undefined) {
                  alert(response.alert)
                }
              }
            })
            $(this).dialog('destroy')
            $deactivateContainer.hide()
          }
        }]
    }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
  })

  $(document).on('input', '.resident-password', function (event) {
    $('.btn-send').prop('disabled', false)
    $('.btn-send').removeClass('ui-state-disabled')
  })

})(document, window.jQuery)

