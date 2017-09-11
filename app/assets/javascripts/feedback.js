(function (document, $) {
  'use strict'

  $(document).on('click', '.feedback-btn', function (event) {
    var dataIn = $(this).data()
    // Note: _ in data content names are translated to camelCase automatically

    var $dialogContainer = $('<div>', { id: 'dialog', class: 'feedback-dialog' })
      .html('<h3>' + dataIn.title + '</h3>' +
        '<div class="icons">' +
          '<div>' +
            '<label class="option">' +
              '<input type="checkbox" class="face option1">' +
              '<span class="feedback option1"></span>' +
            '</label>' +
            '<label class="option">' +
              '<input type="checkbox" class="face option2">' +
              '<span class="feedback option2"></span>' +
            '</label>' +
            '<label class="option">' +
              '<input type="checkbox" class="face option3">' +
              '<span class="feedback option3"></span>' +
            '</label>' +
          '</div>' +

          '<div>' +
            '<label>' + dataIn.option1 + '</label>' +
            '<label>' + dataIn.option2 + '</label>' +
            '<label>' + dataIn.option3 + '</label>' +
          '</div>' +
        '</div>' +

        '<div>' +
          '<label>' + dataIn.comments + '</label>' +
          '<textarea class="comments" id="comments" placeholder=' + "'" + dataIn.placeholder + "'" + '></textarea>' +
        '</div>' +

        '<div class="include-email">' +
          '<label>' + dataIn.sendemail + '</label>' +
          '<input type="checkbox" class="send-email">' +
          '<p>' + dataIn.leaveblank + '</p>' +
        '</div>'
      )

    $(document.body).append($dialogContainer)

    $dialogContainer.dialog({
      show: 'show',
      modal: true,
      dialogClass: 'archive-dialog',
      buttons: [
        {
          text: dataIn.cancel,
          class: 'btn-secondary',
          click: function () {
            $(this).dialog('close')
            $(this).dialog('destroy').remove()
          }
        },
        {
          text: dataIn.submit,
          class: 'btn-primary',
          id: 'btn_confirm',
          click: function () {
            var $comments = $('.comments')
            var commentText = $comments[0].value

            var $option = $('.face:checked')
            var optionText = ''
            if ($option.length > 0) {
              optionText = $option[0].className.substring(5)
            }

            var data = { comments: commentText, option: optionText }
            var $sendEmail = $('.send-email:checked')
            if ($sendEmail.length > 0) {
              data.email = dataIn.emailaddr
            }

            $.getJSON({
              url: '/feedback',
              data: data
            })

            $(this).dialog('close')
            $(this).dialog('destroy').remove()
          }
        }]
    }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
  })

  $(document).on('click', '.feedback', function (event) {
    var eventClassName = '.' + event.target.className.substring(9)
    var $options = $('.option')
    $options.find('input').not(eventClassName).prop('checked', false)
  })
})(document, window.jQuery)
