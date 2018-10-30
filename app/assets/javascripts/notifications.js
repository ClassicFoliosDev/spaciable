/* global $ */

$(document).on('click', '.notification', function (event) {
  var dataIn = $(this).data()

  $('.notification-sender-name').html(dataIn.sendername)
  $('.notification-sender-job-title').html(dataIn.jobtitle)
  $('.notification-subject').html(dataIn.subject)
  $('.notification-message').html(dataIn.message)
  $('.notification-full-avatar').attr('src', dataIn.imageurl)

  setNotificationRead(dataIn.id)

  $(event.target).closest('.notification').find('.new').hide()
})

function setNotificationRead (notificationId) {
  $.getJSON({
    url: '/homeowners/notification/',
    data: { notification_id: notificationId }
  }).done(function (results) {
    $('.unread').html(results)
  })
}
