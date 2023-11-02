document.addEventListener('turbolinks:load', function () {

  unlatch.sync_buttons().each(function( index ) {
    unlatch.click_on($(this))
  })
})

var unlatch = {
  click_on: function(button) {
    // Handle the button clicks
    button.click(function() {
      object = $(this).data('linkable-id')
      unlatch.set_status(object, "synchronising")

      $.post({
            url: "/unlatch/sync_with_unlatch/" + $(this).data('linkable-type') + "/" + $(this).data('linkable-id'),
            dataType: 'json',
            success: function (response) {
               unlatch.set_status(response['linkable_id'], response['sync_status'])
            }
          })
    })
  },

  set_status: function(object, status) {
    icon = $("button[data-linkable-id=" + object + "] i")
    icon.removeClass()
    switch(status) {
      case "synchronising":
        icon.addClass("fa fa-fas fa-spinner fa-spin synchronising")
        break;
      case "linked":
        icon.addClass("fa fa-fas fa-link")
        break;
      case "unlinked":
        icon.addClass("fa fa-fas fa-chain-broken")
        break;
      default:
        icon.addClass("fa fa-fas fa-sync unsynchronised")
    }
  },

  sync_buttons: function() {
    return $("button[data-type='sync']")
  }
}


