(function (document, $) {
  'use strict'

  document.addEventListener('turbolinks:load', function (event) {

    if ($('#material').length == 0) { return }

    $('.tabspan').each(function(tab) {
      $(this).on('click', function (event) {
        tab_selected($(this).parent())
      })
    })

    $("#plot_material_info_attributes_property_construction").selectmenu({
      select: function (event, ui) {
        check_property_construction()
      }
    })

    $("#plot_material_info_attributes_electricity_supply").selectmenu({
      select: function (event, ui) {
        check_electricity()
      }
    })

    tab_selected($('.tab').first())
    check_property_construction()
    check_electricity()
  })

  function check_property_construction() {
    $('.plot_material_info_property_construction_other').toggle($('#plot_material_info_attributes_property_construction').val() == 'plot_construction_other')
  }

  function check_electricity() {
    $('.plot_material_info_electricity_supply_other').toggle($('#plot_material_info_attributes_electricity_supply').val() == 'electricty_other')
  }


  function tab_selected(selected_tab) {
    $('.tab').each(function(tab) {
      $(this).children(":first").toggleClass("active", $(this).is(selected_tab));
      $("div#".concat($(this).attr('id'))).toggle($(this).is(selected_tab))
    })
  }
})(document, window.jQuery)