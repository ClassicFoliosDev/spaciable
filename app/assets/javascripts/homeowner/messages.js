(function (document, $) {
  'use strict'

  $(document).on('input', '.development_message_subject', function (event) {
    toggleSend()
  })

  $(document).on('change keyup', '.message-content', function (event) {
    toggleSend()
  })

  function toggleSend() {
    if (($(".message-content").val().length > 0) && ($("#development_message_subject").val().length > 0)) {
      $(".send").prop('disabled', false)
    } else {
      $(".send").prop('disabled', true)
    }
  }

  $(document).on('change keyup', '.reply-content', function (event) {
    var $sendButton = $(event.target).closest(".message").find(".reply-send")
    if ($(event.target).val().length > 0) {
      $sendButton.prop('disabled', false)
    } else {
      $sendButton.prop('disabled', true)
    }
  })

})(document, window.jQuery)
