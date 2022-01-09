document.addEventListener('turbolinks:load', function (event) {

  var edit_btn = $("a[data-action='edit']")
  var confirm_edit = $("#confirm-edit")

  // Both link and confirmation data need to be present
  if (!(edit_btn.length != 0 && confirm_edit.length != 0)) {
    return
  }

  edit_btn.click(function(event) {
    event.preventDefault();

    var $dialogContainer = $('<div>', { id: 'dialog' })
    $dialogContainer.append(confirm_edit.html())

    $(document.body).append($dialogContainer)

    $dialogContainer.dialog({
      show: 'show',
      modal: true,
      width: 600,
      title: confirm_edit.data("title"),
      buttons: [
        {
          text: "Cancel",
          class: 'btn-secondary',
          click: function () {
            $(this).dialog('close')
            $(this).dialog('destroy').remove()
          }
        },
        {
          text: "Continue",
          id: 'btn_confirm',
          click: function () {
            $(this).dialog('close')
            $(this).dialog('destroy').remove()
            location.replace(edit_btn.attr('href'))
        }
      }]
    }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
  })
})
