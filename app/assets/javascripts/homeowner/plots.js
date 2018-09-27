(function (document, $) {
  'use strict'

  $(document).on('click', '.my-plots', function (event) {
    $('.plot-list').toggleClass('hidden')
  })

  $(document).on('click', '.plot-summary', function (event) {
    $("[data-test='brand-style-overrides']").remove()
  })
})(document, window.jQuery)
