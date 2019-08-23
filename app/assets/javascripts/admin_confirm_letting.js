(function (document, $) {
  'use strict'

  $(document).on('click', '.admin-confirm-letting-type', function (event) {
    var dataIn = $(this).data()

    var $confirmContainer = $('.admin-lettings-account-form')

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
              url: '/lettings_account',
              data: $form.serialize(),
              dataType: 'json'
            })
          }
        }]
    }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
    document.getElementById('lettings_account_management').value = dataIn.type
    document.getElementById('lettings_account_first_name').value = dataIn.firstname
    document.getElementById('lettings_account_last_name').value = dataIn.lastname
    document.getElementById('lettings_account_display_type').innerHTML = dataIn.management
    validateConfirmation()
  })

  $(document).on('input', '.admin-lettings-account-form', function (event) {
    validateConfirmation()
  })

  function validateConfirmation () {
    if (($('input#lettings_account_first_name').val().length > 0) &&
        ($('input#lettings_account_last_name').val().length > 0) &&
        (validateEmail()) ) {
      $('.btn-send').prop('disabled', false)
      $('.btn-send').removeClass('ui-state-disabled')
    } else {
      $('.btn-send').prop('disabled', true)
      $('.btn-send').addClass('ui-state-disabled')
    }
  }

  function validateEmail () {
    var re = /\S+@\S+\.\S+/
    return re.test($('input.email').val())
  }

})(document, window.jQuery)
