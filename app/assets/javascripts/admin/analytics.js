(function (document, $) {
  'use strict'

  $(document).on('mouseup', '.report-targets .ui-menu-item', function (event) {
    var eventVal = event.target.innerHTML
    var $parent = $(event.target).closest('.select-container')
    var $submitButtons =[]

    if ($parent.hasClass('developer-id')) {
      $submitButtons.push($('.developer-csv'))
      $submitButtons.push($('.invoice-csv'))
    } else if ($parent.hasClass('development-id')) {
      $submitButtons.push($('.development-csv'))
    } else {
      return
    }

    for (let i = 0; i < $submitButtons.length; i++) {
      $submitButtons[i].prop('disabled', eventVal === 'Choose...')
    }
  })
})(document, window.jQuery)

function reportSubmitted() {
  var $flash = $('.flash')
  $flash.empty()

  var $notice = document.createElement('p')
  var timeNow = new Date();
  var time = timeNow.getHours() + ":" + timeNow.getMinutes() + ":" + timeNow.getSeconds();
  $notice.className = 'notice'
  $notice.innerHTML = 'Your report (requested ' + time + ') is being processed. You will receive an email shortly.'
  $flash.append($notice)
};
