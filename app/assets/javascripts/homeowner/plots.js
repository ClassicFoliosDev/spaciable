(function (document, $) {
  'use strict'

  $(document).on('click', '.swap-plot-btn', function (event) {
    $("[data-test='brand-style-overrides']").remove()
  })
})(document, window.jQuery)
