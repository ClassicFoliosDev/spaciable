/* global $ */

(function (document, $) {
  'use strict'

  $(document).on('mouseup', '.report-targets .ui-menu-item', function(event) {
    var eventVal = event.target.innerHTML
    var $parent = $(event.target).closest(".select-container")
    var $submitButton

    if ($parent.hasClass("developer-id")) {
      $submitButton = $(".developer-csv")
    } else if ($parent.hasClass("development-id")) {
      $submitButton = $(".development-csv")
    } else {
      return
    }

    if (eventVal == "Choose...") {
      $submitButton.prop('disabled', true)
    }
    else {
      $submitButton.prop('disabled', false)
    }
  })

})(document, window.jQuery)
