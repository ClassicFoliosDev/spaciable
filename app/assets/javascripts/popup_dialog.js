var $resources = []

document.addEventListener('turbolinks:load', function () {

  $(".popup-resource").each(function( index ) {

    $resources[index] = $(this)

    if ($(this).data('selector') == "") {
      selector = popup.addToolbarLink($(this), index)
      $(selector).show()
    } else {
      selector = $(this).data('selector')
      $(selector).data('resource', index)
    }

    if ($(this).data("popup-on-load")) { popup.show($(this), true) }

    $(document).on('click', selector, function (event) {
      if ($(".ui-dialog").is(":visible")) { return }
      popup.display($resources[$(this).data('resource')], false)
    })
  })
})

var popup = {

  show: function(resource, can_turn_off) {
    var dataIn = resource.data()

    if(getCookie(resource.data("preference")) != "true") {
        popup.display(resource, can_turn_off)
    }
  },

  display: function(resource, can_turn_off){
    dataIn = resource.data()

    var $dialogContainer = $('<div>', { id: 'dialog' }).html(resource.html())
    if (can_turn_off) {

      if(resource.data('selector') == "" && resource.data("icon") != "") {
        $dialogContainer.append("<div>" +
                                  "<p>To recall this message, click the " +
                                  "<i class='fa " + resource.data("icon") + " " + resource.data("type") + "' aria-hidden='true'></i>" +
                                  " in the top right.</p>" +
                                "</div>")
      } else if (resource.data('recall') != "") {
        $dialogContainer.append("<div>" + resource.data('recall') + "</div>")
      }

      $dialogContainer.append("<div class='input'>" +
                                "<label><input type='checkbox' id='noshow' name='noshow'>I understand. Please don't show this message again.</label>" +
                              "</div>")
    }

    $('body').append($dialogContainer)

    dialog = $dialogContainer.dialog()

    dialog.data( "uiDialog" )._title = function(title) {
      title.html( this.options.title );
    };

    dialog.dialog('option', 'title', '<i class="fa ' + resource.data("icon") + " " + resource.data("type") + ' aria-hidden="true"></i>' + dataIn.title);

    dialog.dialog({
      show: 'show',
      modal: true,
      width: dataIn.width,
      dialogClass: resource.data("type") + '-dialog',
      buttons: [
      {
        text: 'Close',
        class: 'btn-cancel',
        click: function () {
          if ($('#noshow').is(":checked")) {
            setCookie(resource.data("preference"), true, 10000)
          }
          $(".ui-widget-overlay").remove()
          $(this).dialog('close')
          $(this).dialog('destroy').remove()
        }
      }]
    }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button

    $('body').append("<div class='ui-widget-overlay ui-front' style='z-index: 100;''></div>")
  },

  addToolbarLink: function(resource, index) {
    if (resource.data("type") == 'button') {
      $(".breadcrumb-container").append("<button id='toolbarbutton' type='button' class='btn toolbarbutton' data-resource='" + index +"'>" +
                                        resource.data('title') +
                                        "</button>")
      return "#toolbarbutton"
    }
    if (resource.data("type") == "") { return }
    if ($("i." + resource.data("icon")).length > 0) { return }
    var toolbarIcon = $('<div>', { id: resource.data("type") }).html('<i class="fa ' +
                        resource.data("icon") + " " +
                        resource.data("type") +
                        ' aria-hidden="true"' +
                        ' data-resource="' + index +'" ></i>')
    $(".breadcrumb-container").append(toolbarIcon)
    return "i." + resource.data("type")
  }
}
