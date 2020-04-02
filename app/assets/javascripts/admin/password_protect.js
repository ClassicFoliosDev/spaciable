/* global alert */

(function (document, $) {
  'use strict'

  $(document).on('click', '.destroy-permissable', function (event) {
    var dataIn = $(this).data()

    var $destroyContainer = $('<div>', { id: 'destroyPermissable', class: 'destroy-permissable-form' })
        .html(
          '<div>' +
            '<p>' +
              'By deleting ' + dataIn.name + ' you will delete ' +
              dataIn.plots + ' plots and all associated admin users from Spaciable.' +
            '</p>' +
          '</div>' +
          '<div>' +
            '<p>' +
              'If you are sure you want to delete ' + dataIn.name + ', enter your password below to confirm.' +
            '</p>' +
          '</div>' +
          '<div class="destroy-permissable-form>' +
            '<form autocomplete="off">' +
              '<input class="user-password" type="password" id="password" name="password" autocomplete="off">' +
            '</form>' +
          '</div>'
        )

    $('body').append($destroyContainer)

    $destroyContainer.dialog({
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
            var password = $('.user-password')[0].value
            $.ajax({
              url: dataIn.path,
              type: 'DELETE',
              data: { password: password },
              success: function (response) {
                if (response.alert !== undefined) {
                  alert(response.alert)
                }
              }
            })
            .fail(function() {
              var $flash = $('.flash')
              $flash.empty()

              var $notice = document.createElement('p')
              $notice.className = 'alert'
              $notice.innerHTML = "An error occurred. Please try again later."
              $flash.append($notice)
            })

            $(this).dialog('destroy')
            $destroyContainer.hide()
          }
        }]
    }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
  })

  $(document).on('input', '.user-password', function (event) {
    $('.btn-send').prop('disabled', false)
    $('.btn-send').removeClass('ui-state-disabled')
  })
})(document, window.jQuery)
