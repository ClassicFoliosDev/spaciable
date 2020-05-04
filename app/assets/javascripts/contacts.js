
// Set the contact position to the value of a selected postion type
document.addEventListener('turbolinks:load', function () {
  var $positionSelect = $('.contact_contact_type select, change')

  $positionSelect.selectmenu({
    select: function (event, ui) {
      $('#contact_position').val(ui.item.label)
    }
  })
})

