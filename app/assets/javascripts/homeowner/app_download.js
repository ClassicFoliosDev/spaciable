(function (document, $) {
  'use strict'

  /* Trigger the app download reminder on page load (dashboard only) */
  document.addEventListener('turbolinks:load', function (event) {
    var element = document.getElementById("app-reminder");
    // get the value of the tour cookie to prevent the popup if it is active
    var tourCookie = document.cookie.match(("(^|[^;]+)\\s*" + "dashboard_tour" + "\\s*=\\s*([^;]+)"))
    var tourValue = tourCookie ? tourCookie.pop() : ""

      if (element !== null && tourValue !== "show") {
        var osCheck = navigator.userAgent.toLowerCase();
        // check whether user is using gonative, if not check for android or iphone (covers ipad)
        if (osCheck.indexOf("gonative") === -1 &&
           (osCheck.indexOf("android") > -1 || osCheck.indexOf("iphone") > -1)) {
          showAppDownload()
        }
      }
  })

  /**
  Modal to inform the resident about the app download.
  Resident has option to click "don't show this again",
  otherwise we show it every time the dashboard is loaded
  */
  function showAppDownload() {
    var cookies = document.cookie
    var index = cookies.indexOf('app_download')
    var downloadCookie = cookies.substring(index)

    if (index === -1) {
      document.cookie = 'app_download=show'
      downloadCookie = 'app_download=show'
    }

    var $appReminder = $('.app-download')

    // just check cookie is present.  May be multiple cookies listed
    if (downloadCookie.indexOf('app_download=show') != -1 && $appReminder.length > 0) {
      var $footer = $('.app-download-footer')

      $appReminder.dialog({
        width: 350,
        height: 400,
        dialogClass: 'app-download-dialog',
        create: function () {
          $footer.show()
          $('.app-download-dialog').append($footer)
        },
        buttons: [
          {
            text: $appReminder.data().cta,
            class: 'dialog-btn app-dismiss',
            id: "appDismissBtn",
            click: function () {
              $(this).dialog('close')
            }
          }
        ]
      })

      $('.ui-dialog-titlebar').hide() // Hide the standard title bar and close button
      $("#appDismissBtn").html('<i class="fa fa-times"></i>')

      var background = document.getElementById("homeowner-main")
      background.className += " is-blurred"
    }
  }

  /* Button to turn off the sharing modal permanently */
  $(document).on('click', '.hide-app-download', function (event) {
    document.cookie = 'app_download=hide'
    var $appReminder = $('.app-download')
    $appReminder.dialog('close')
    $appReminder.dialog('destroy').remove()

    var background = document.getElementById("homeowner-main")
    background.className -= " is-blurred"
  })

  // Remove the blur effect when clicking off
  $(document).on('click', '.app-dismiss', function (event) {
    var background = document.getElementById("homeowner-main")
    background.className -= " is-blurred"
  })

  $(document).on('click', '#app-download-btn', function (event) {
    var $appReminder = $('.app-download')
    $appReminder.dialog('close')

    var background = document.getElementById("homeowner-main")
    background.className -= " is-blurred"
  })

})(document, window.jQuery)
