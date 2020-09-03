(function (document, $) {
  'use strict'

  // Trigger the browser support popup on page load (dashboard only)
  // Check for support div and browder type
  document.addEventListener('turbolinks:load', function (event) {
    if (($("#browserSupport").length) && (/Chrome/.test(navigator.userAgent))) {
      showBrowserSupport()
    }
  })

  // Modal to inform the user about browser support for IE
  // User has option to click "don't show this again",
  // else it shows each time dashboard loads (expires each session)
  function showBrowserSupport() {
    var index = document.cookie.indexOf('browser_support')
    var supportCookie = document.cookie.substring(index)

    if (index === -1) {
      document.cookie = 'browser_support=show'
      supportCookie = 'browser_support=show'
    }

    var $browserSupport = $('.browser-support')

    if (supportCookie === ('browser_support=show') && $browserSupport.length) {
      $browserSupport.dialog({
        width: 750,
        height: 400,
        dialogClass: 'browser-support-dialog',
        buttons: [
          {
            class: 'dialog-btn dialog-dismiss',
            id: "browserDismissBtn",
            click: function () {
              $(this).dialog('close')
              $(".outer-container, .copyright-footer").removeClass("is-blurred")
            }
          }
        ]
      })

      $('.ui-dialog-titlebar').hide() // Hide the standard title bar and close button
      $("#browserDismissBtn").html('<i class="fa fa-times"></i>')

      // add blur class to background
      $(".outer-container, .copyright-footer").addClass("is-blurred")
    }
  }

  // Turn off browser support modal permanently
  $(document).on('click', '.hide-browser-support', function (event) {
    var $browserSupport = $('.browser-support')
    $browserSupport.dialog('close')
    $browserSupport.dialog('destroy').remove()

    // update cookie
    document.cookie = 'browser_support=hide'

    // remove blur class from background
    $(".outer-container, .copyright-footer").removeClass("is-blurred")
  })

})(document, window.jQuery)
