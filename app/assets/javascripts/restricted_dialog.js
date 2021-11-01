var $restrictedResource = null

document.addEventListener('turbolinks:load', function () {

  $restrictedResource = $(".restricted-resource")
  if ($restrictedResource.length == 0 ) { return }

  restricted.show(true)
  $("i.restricted-warning").show()

  $(document).on('click', 'i.restricted-warning', function (event) {
    restricted.display(false)
  })

})

var restricted = {

  show: function(can_turn_off) {
    var dataIn = $restrictedResource.data()

    $.getJSON({
      url: '/user_preferences/preference',
      data: { 'preference' : dataIn.preference }
    }).done(function (results) {
      if (results['on']) {
        restricted.display(can_turn_off)
      }
    })
  },

  display: function(can_turn_off){
    dataIn = $restrictedResource.data()

    var $dialogContainer = $('<div>', { id: 'dialog' }).html($restrictedResource.html())
    if (can_turn_off) {
      $dialogContainer.append("<div>" +
                                "<input type='checkbox' id='noshow' name='noshow'>" +
                                "<label for='noshow'>Please dont show me this message again.</label>" +
                              "</div>")
    }

    $('body').append($dialogContainer)

    dialog = $dialogContainer.dialog()

    dialog.data( "uiDialog" )._title = function(title) {
      title.html( this.options.title );
    };

    dialog.dialog('option', 'title', '<i class="fa fa-exclamation-triangle restricted-warning" aria-hidden="true"></i>' + dataIn.title);

    dialog.dialog({
      show: 'show',
      modal: true,
      width: 400,
      dialogClass: 'restricted-dialog',
      buttons: [
      {
        text: 'Close',
        class: 'btn-cancel',
        click: function () {
          if ($('#noshow').is(":checked")) {
            $.post('/user_preferences/set_preference',
                    {'preference': dataIn.preference, 'on': false}
                  )
          }
          $(this).dialog('close')
          $(this).dialog('destroy').remove()
        }
      }]
    }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button

  }
}
