/* global $ */

document.addEventListener('turbolinks:load', function () {
  var $dashboardFaqs = $('body.homeowner-view .faqs')

  if ($dashboardFaqs.length > 0) {
    var faqAnchor = window.location.hash
    var $faq = $(faqAnchor)
    var faqIndex = $dashboardFaqs.find('dt').index($faq)

    if (faqIndex > -1) {
      $dashboardFaqs.accordion({active: faqIndex, heightStyle: 'content'})
      $('body').scrollTop($faq.position().top)
    } else {
      $dashboardFaqs.accordion({heightStyle: 'content'})
    }
  }
})

// send the positive feedback on positive response
$(document).on('click', '#positiveFAQ', function (event) {
  var dataIn = $(this).data()
  var data = { question: dataIn.question, email: dataIn.email,
               plot: dataIn.plot, response: 1, feedback: $("#feedbackInput").val() }

  $("#feedback-" + dataIn.id).hide()
  $("#positive-" + dataIn.id).show()

  $.getJSON({
    url: '/faq_feedback',
    data: data
  })
})

// show the feedback form on negative response
$(document).on('click', '#negativeFAQ', function (event) {
  var dataIn = $(this).data()
  $("#feedback-" + dataIn.id).hide()
  $("#negative-" + dataIn.id).show()
})

// send the negative feedback
$(document).on('click', '#faqFeedbackSend', function (event) {
  var dataIn = $(this).data()

  if ($("#input-" + dataIn.id).val().length > 0) {
    // send the feedback
    var data = { question: dataIn.question, email: dataIn.email,
                 plot: dataIn.plot, response: 0, feedback: $("#input-" + dataIn.id).val() }

    $.getJSON({
      url: '/faq_feedback',
      data: data
    })

    // hide the feedback form and show confirmation
    $("#negative-" + dataIn.id).hide()
    $("#positive-" + dataIn.id).show()

  } else {
    // alert to enter feedback
    var $alert = $('<div>', { id: 'alertInput' })
      .html("<span class='faq-alert'>" + "Please enter valid feedback." + "</span>")

    $("#negative-" + dataIn.id + " .disclaimer").append($alert)
  }
})
