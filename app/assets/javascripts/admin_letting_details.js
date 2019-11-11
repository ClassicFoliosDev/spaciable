(function (document, $) {
  'use strict'

  $(document).on('click', '.admin-let-plot', function (event) {
    var dataIn = $(this).data()

    var $lettingContainer = $('.admin-let-plot-details-form')

    $('body').append($lettingContainer)
    var $form = $('.letting')

    $lettingContainer.dialog({
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

            $.post({
              url: dataIn.url,
              data: $form.serialize(),
              dataType: 'json',
              success: function (response) {
                window.location=response
              }
            })
            $(this).dialog('destroy')
            $lettingContainer.hide()
          }
        }]
    }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
    document.getElementById('letting_address_1').value = dataIn.address1
    document.getElementById('letting_address_2').value = dataIn.address2
    document.getElementById('letting_town').value = dataIn.town
    document.getElementById('letting_postcode').value = dataIn.postcode
    document.getElementById('letting_plot_id').value = dataIn.plot
    document.getElementById('letting_other_ref').value = "spaciable" + dataIn.plot
    document.getElementById('letting_country').value =  dataIn.country
    document.getElementById('letting_bedrooms').value =  dataIn.bedrooms
    document.getElementById('letting_bathrooms').value =  dataIn.bathrooms
    document.getElementById('letting_notes').value =  "None"

    validateLetting()
  })

  $(document).on('input', '.admin-let-plot-details-form', function (event) {
    validateLetting()
  })

  function validateLetting () {
    if (($('input#letting_price').val() > 0) && ($('input#letting_price').val() < 99999) &&
        ($('input#letting_bedrooms').val() > 0) && ($('input#letting_bedrooms').val() < 99) &&
        ($('input#letting_bathrooms').val() > 0) && ($('input#letting_bathrooms').val() < 99) &&
        ($('input#letting_address_1').val().length > 0) && ($('input#letting_address_2').val().length > 0) &&
        ($('input#letting_town').val().length > 0) && ($('input#letting_postcode').val().length > 4) &&
        ($('input#letting_notes').val().length > 0) &&
        ($('textarea#letting_summary').val().length > 0) ){
      $('.btn-send').prop('disabled', false)
      $('.btn-send').removeClass('ui-state-disabled')
    } else {
      $('.btn-send').prop('disabled', true)
      $('.btn-send').addClass('ui-state-disabled')
    }
  }

})(document, window.jQuery)
