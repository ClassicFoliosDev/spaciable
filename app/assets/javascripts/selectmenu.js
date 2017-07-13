/* global $ */
document.addEventListener('turbolinks:load', function () {
  $('select').not('.skip-global-selectmenu select').selectmenu()

  $('select#finish_manufacturer_finish_type_ids').select2({ width: 400 })
})
