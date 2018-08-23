(function (document, $) {
  'use strict'

  $(document).on('click', '.my-plots', function (event) {
    $('.plot-list').toggle()
  })

  $(document).on('click', '.plot-summary', function (event) {
    $("[data-test='brand-style-overrides']").remove()
  })
})(document, window.jQuery)
