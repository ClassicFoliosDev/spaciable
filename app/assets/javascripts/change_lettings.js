(function (document, $) {
  'use strict'

  $(document).on('click', '.change-letter-btn', function (event) {
    var dataIn = $(this).data()

    var $changeContainer = $('.change_letting_plot_' + dataIn.plot)

    $('body').append($changeContainer)
    var $form = $('.edit_plot')

    $changeContainer.dialog({
      show: 'show',
      modal: true,
      width: 700,
      title: dataIn.title,
      buttons: [
        {
          text: dataIn.cancel,
          class: 'btn',
          click: function () {
            $(this).dialog('destroy')
          }
        },
        {
          text: dataIn.cta,
          class: 'btn-send btn',
          id: 'btn_submit',
          click: function () {

            $.ajax({
              url: '/plots/' + dataIn.plot,
              data: $form.serialize(),
              type: 'PUT'
            })

            $(this).dialog('destroy')
            $changeContainer.hide()
          }
        }]
    }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
  })

  $(document).on('click', '.remove-letter-btn', function (event) {
    var dataIn = $(this).data()

    var $changeContainer = $('.remove_letting_plot_' + dataIn.plot)

    $('body').append($changeContainer)
    var $form = $('.edit_plot')

    $changeContainer.dialog({
      show: 'show',
      modal: true,
      width: 700,
      title: dataIn.title,
      buttons: [
        {
          text: dataIn.cancel,
          class: 'btn',
          click: function () {
            $(this).dialog('destroy')
          }
        },
        {
          text: dataIn.cta,
          class: 'btn-send btn',
          id: 'btn_submit',
          click: function () {

            $.ajax({
              url: '/plots/' + dataIn.plot,
              data: $form.serialize(),
              type: 'PUT'
            })

            $(this).dialog('destroy')
            $changeContainer.hide()
          }
        }]
    }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
  })

})(document, window.jQuery)
