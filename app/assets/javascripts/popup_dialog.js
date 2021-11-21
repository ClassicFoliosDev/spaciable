var $popupResource = null

document.addEventListener('turbolinks:load', function () {

  $popupResource = $(".popup-resource")
  if ($popupResource.length == 0 ) { return }
  if ($popupResource.data("popup-on-load")) { popup.show(true) }

  popup.buildToolbarIcon()

  toolbar_icon = "i." + $popupResource.data("type")

  $(toolbar_icon).show()

  $(document).on('click', toolbar_icon, function (event) {
    if ($(".ui-dialog").is(":visible")) { return }
    popup.display(false)
  })

})

var popup = {

  show: function(can_turn_off) {
    var dataIn = $popupResource.data()

    $.getJSON({
      url: '/user_preferences/preference',
      data: { 'preference' : dataIn.preference }
    }).done(function (results) {
      if (results['on']) {
        popup.display(can_turn_off)
      }
    })
  },

  display: function(can_turn_off){
    dataIn = $popupResource.data()

    var $dialogContainer = $('<div>', { id: 'dialog' }).html($popupResource.html())
    if (can_turn_off) {
      $dialogContainer.append("<div class='input'>" +
                                "<label><input type='checkbox' id='noshow' name='noshow'>Please dont show me this message again.</label>" +
                              "</div>")
    }

    $('body').append($dialogContainer)

    dialog = $dialogContainer.dialog()

    dialog.data( "uiDialog" )._title = function(title) {
      title.html( this.options.title );
    };

    dialog.dialog('option', 'title', '<i class="fa ' + $popupResource.data("icon") + " " + $popupResource.data("type") + ' aria-hidden="true"></i>' + dataIn.title);

    dialog.dialog({
      show: 'show',
      modal: true,
      width: dataIn.width,
      dialogClass: $popupResource.data("type") + '-dialog',
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

  },

  buildToolbarIcon: function() {
    var $toolbarIcon = $('<div>', { id: $popupResource.data("type") }).html('<i class="fa ' + $popupResource.data("icon") + " " + $popupResource.data("type") + ' aria-hidden="true"></i>')
    $(".breadcrumb-container").append($toolbarIcon)
  }
}
