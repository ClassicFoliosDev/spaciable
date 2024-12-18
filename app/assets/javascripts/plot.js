(function (document, $) {
  'use strict'

  var dependencies = [{primary: '#plot_material_info_attributes_property_construction',
                       dependant: '.plot_material_info_property_construction_other',
                       triggers: ['plot_construction_other']},
                      {primary: '#plot_material_info_attributes_electricity_supply',
                       dependant: '.plot_material_info_electricity_supply_other',
                       triggers: ['electricty_other']},
                      {primary: '#plot_material_info_attributes_sewerage',
                       dependant: '.plot_material_info_sewerage_other',
                       triggers: ['sewerage_other']},
                      {primary: '#plot_material_info_attributes_mobile_signal',
                       dependant: '.plot_material_info_mobile_signal_restrictions',
                       triggers: ['restricted']},
                      {primary: '#plot_material_info_attributes_tenure',
                       dependant: '.plot_material_info_lease_length',
                       triggers: ['leasehold']},
                      {primary: '#plot_material_info_attributes_property_type',
                       dependant: '.plot_material_info_floor',
                       triggers: ['apartment','duplex','maisonette','studio']}]

  document.addEventListener('turbolinks:load', function (event) {

    if ($('#metadata').length == 0) { return }

    $('.tabspan').each(function(tab) {
      $(this).on('click', function (event) {
        tab_selected($(this).parent())
      })
    })

    dependencies.forEach(function(dependency) {
      $(dependency.primary).selectmenu({
        select: function (event, ui) {
          check_dependency(dependency)
        }
      })
      check_dependency(dependency)
    })  

    tab_selected($('.tab').first())
  })

  function check_dependency(dependency) {
    $(dependency.dependant).toggle(jQuery.inArray($(dependency.primary).val(), dependency.triggers) !== -1)
  }

  function tab_selected(selected_tab) {
    $('.tab').each(function(tab) {
      $(this).children(":first").toggleClass("active", $(this).is(selected_tab));
      $("div#".concat($(this).attr('id'))).toggle($(this).is(selected_tab))
    })
  }
})(document, window.jQuery)