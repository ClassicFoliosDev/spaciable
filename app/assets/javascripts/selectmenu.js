(function (document, $) {
  'use strict'
  document.addEventListener('turbolinks:render', function () {
    $('select').not('.skip-global-selectmenu select').selectmenu()
    $('select#finish_manufacturer_finish_type_ids').select2({ width: 400 })
    $('.skip-global-selectmenu select').hide()
  })

  document.addEventListener('turbolinks:load', function () {
    $('select').not('.skip-global-selectmenu select').selectmenu()
    $('select#finish_manufacturer_finish_type_ids').select2({ width: 400 })
    $('.skip-global-selectmenu select').hide()
  })

  document.addEventListener('turbolinks:render', function () {
    $('select').not('.skip-global-selectmenu select').selectmenu()
    $('select#finish_type_finish_category_ids').select2({ width: 400 })
    $('.skip-global-selectmenu select').hide()
  })

  document.addEventListener('turbolinks:load', function () {
    $('select').not('.skip-global-selectmenu select').selectmenu()
    $('select#finish_type_finish_category_ids').select2({ width: 400 })
    $('.skip-global-selectmenu select').hide()
  })

  document.addEventListener('turbolinks:render', function () {
    $('select').not('.skip-global-selectmenu select').selectmenu()
    $('select#phase_timeline_plot_ids').select2({ width: 400 })
    $('.skip-global-selectmenu select').hide()
  })

  document.addEventListener('turbolinks:load', function () {
    $('select').not('.skip-global-selectmenu select').selectmenu()
    $('select#phase_timeline_plot_ids').select2({ width: 400 })
    $('.skip-global-selectmenu select').hide()
  })

  document.addEventListener('turbolinks:before-cache', function () {
    $('select#finish_manufacturer_finish_type_ids').select2('destroy')
    $('select').selectmenu('destroy')
    $('.cke_editor_notification_message').remove()
  })
})(document, window.jQuery)



