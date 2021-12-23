/* global $, clearFields, setFields */

document.addEventListener('turbolinks:load', function () {

  form = $(".new_finish_filter")
  if (form.length == 0) { return }

  controls = [
    $('.finish_filter_finish_category_id select'),
    $('.finish_filter_finish_type_id select'),
    $('.finish_filter_finish_manufacturer_id select')
  ];

  for (i = 0; i < controls.length; ++i) {
    controls[i].selectmenu({
      select: function (event, ui) {
        window.location = form.attr('action') + '?' + form.serialize()
      }
    })
  }
})
