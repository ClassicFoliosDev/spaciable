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

  document.addEventListener('turbolinks:load', function () {
    create_select2('select#plot_material_info_attributes_heating_fuel_ids')
    create_select2('select#plot_material_info_attributes_heating_source_ids')
    create_select2('select#plot_material_info_attributes_heating_output_ids')
  })

  document.addEventListener('turbolinks:load', function () {
    create_select2('select#development_material_info_attributes_heating_fuel_ids')
    create_select2('select#development_material_info_attributes_heating_source_ids')
    create_select2('select#development_material_info_attributes_heating_output_ids')
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

function create_select2(select) {
  $('select').not('.skip-global-selectmenu select').selectmenu()
  $(select).select2({ width: '100%' })
  $('.skip-global-selectmenu select').hide()
};



