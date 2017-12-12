(function (document, $) {
  'use strict'

  $(document).on('click', '.navbar-trigger-label', function (event) {
    $(".navbar-menu").toggle()
  })
})(document, window.jQuery)
