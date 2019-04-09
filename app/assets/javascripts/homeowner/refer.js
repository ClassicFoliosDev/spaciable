(function (document, $) {
  'use strict'

  $(document).on('click', '.refer-resident', function (event) {
    var dataIn = $(this).data()

    var $referContainer = $('.refer-resident-form')

    $('body').append($referContainer)
    var $form = $('.new_referral')

    $referContainer.dialog({
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

            $.post({
              url: '/homeowners/refer_friend',
              data: $form.serialize(),
              dataType: 'json',
              success: function (response) {
                var $flash = $('.flash')
                $flash.empty()

                var $notice = document.createElement('p')
                $notice.className = 'notice'
                $notice.innerHTML = response.notice
                $flash.append($notice)
              }
            })
            $(this).dialog('destroy')
            $referContainer.hide()
          }
        }]
    }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button

    validateSendReferral()
  })

  $(document).on('input', '.refer-resident-form', function (event) {
    validateSendReferral()
  })

  function validateSendReferral () {
    if (($('input#referral_referee_first_name').val().length > 0)
        && ($('input#referral_referee_last_name').val().length > 0) && validateEmail()) {
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
