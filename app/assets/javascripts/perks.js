(function (document, $) {
  'use strict'

  $(document).on('click', '.activate-perks-account', function (event) {
    var dataIn = $(this).data()
    var $form = $('.new_perk')

    $.post({
      url: dataIn.url,
      data: $form.serialize(),
      dataType: 'json',
      success: function (response) {
        window.location = response['url']
      }
    })
    .fail(function() {
      var $flash = $('.flash')
      $flash.empty()

      var $notice = document.createElement('p')
      $notice.className = 'alert'
      $notice.innerHTML = "Cannot contact the server, please try again later."
      $flash.append($notice)
    })
  })

})(document, window.jQuery)
