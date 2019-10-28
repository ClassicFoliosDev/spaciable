(function (document, $) {
  'use strict'

  $(document).on('click', '.change-listing-owner-btn', function (event) {
    var dataIn = $(this).data()

    var $changeContainer = $('.change_listing_' + dataIn.listing)

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
              url: dataIn.url + '/?owner=' + dataIn.owner,
              data: $form.serialize(),
              type: 'PUT'
            })

            $(this).dialog('destroy')
            $changeContainer.hide()
          }
        }]
    }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
  })

  $(document).on('click', '.remove-listing-btn', function (event) {
    var dataIn = $(this).data()

    var $changeContainer = $('.remove_listing_' + dataIn.listing)

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
              url: dataIn.url,
              data: $form.serialize(),
              type: 'DELETE'
            })

            $(this).dialog('destroy')
            $changeContainer.hide()
          }
        }]
    }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
  })

})(document, window.jQuery)
