document.addEventListener('turbolinks:load', function () {

  plots.sync_buttons().each(function( index ) {
    plots.click_on($(this))
  })
})

var plots = {
  click_on: function(button) {
    // Handle the button clicks
    button.click(function() {
      plot = $(this).data('plot')
      plots.set_status(plot, "synchronising")

      $.post({
            url: "/plots/" + $(this).data('plot') + "/sync_with_unlatch",
            dataType: 'json',
            success: function (response) {
               plots.set_status(response['plot'], response['sync_status'])
            }
          })
    })
  },

  set_status: function(plot, status) {
    icon = $("button[data-plot=" + plot + "] i")
    icon.removeClass()
    switch(status) {
      case "synchronising":
        icon.addClass("fa fa-fas fa-spinner fa-spin synchronising")
        break;
      case "unsynchronised":
        icon.addClass("fa fa-fas fa-sync unsynchronised")
        break;
      case "no_match":
        icon.addClass("fa fa-fad fa-bug no_match")
        break;
      case "synchronised":
        icon.addClass("fa fa-fas fa-sync synchronised")
        break;
      case "failed_to_synchronise":
        icon.addClass("fa fa-fas fa-sync failed_to_synchronise")
        break;
      default:
        icon.addClass("fa fa-fas fa-sync unsynchronised")
    }
  },

  sync_buttons: function() {
    return $("button[data-type='sync']")
  }
}


