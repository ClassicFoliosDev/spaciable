(function (document, $) {
  'use strict'

  $(document).on('click', '.notification', function (event) {
    $(window).scrollTop(0);
  })

})(document, window.jQuery)

$(document).on('turbolinks:load', function () {
  var notification_list = $(".notification-list")
  if(notification_list.length == 0 ) { return }

  preload = notification_list.data('note_id')
  if (preload != "") { $("div").find(`[data-id='${preload}']`).trigger('click') }
})
