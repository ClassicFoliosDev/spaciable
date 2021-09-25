var $helpResource = null

document.addEventListener('turbolinks:load', function () {

  $helpResource = $(".help-resource")
  if ($helpResource.length == 0 ) { return }

  admin_help.show()
})

var admin_help = {

  show: function() {
    var dataIn = $helpResource.data()

    $.getJSON({
      url: '/user_preferences/preference',
      data: { 'preference' : dataIn.preference }
    }).done(function (results) {
      if (results['on']) {
        admin_help.display(dataIn)
      }
    })
  },

  display: function(dataIn){
    var $dialogContainer = $('<div>', { id: 'dialog' }).html($helpResource.html())
    $dialogContainer.append("<div>" +
                              "<input type='checkbox' id='noshow' name='noshow'>" +
                              "<label for='noshow'>Please dont show me this message again.</label>" +
                            "</div>")

    $('body').append($dialogContainer)

    $dialogContainer.dialog({
      show: 'show',
      modal: true,
      width: 400,
      dialogClass: 'help-dialog',
      title: dataIn.title,
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
