/* global $ */
var $body = $('body')

$(document).on('click', '#timeline-submit-btn', function (event) {

  var $form = $("#timeline_task")

  // set the reponse according to the data content of the button
  response = event.currentTarget.getAttribute('data-response')
  $("[name='response']").val(response)

  // if the response is negative
  if (response == 'negative') {
    // reveal the answer
    $('#question').hide()
    $('#answer').show()

    // record the negative response
    $.post({
      url: $form.attr('action'),
      data: $form.serialize(),
      dataType: 'json'
    }).done(function (results) {
      // Change the format for the current timeline entry to No
    }).fail(function (response) {
      flash("Failed to record response", 'alert')
    })
  } else {
    $form.submit(); // Form submission
  }

})
