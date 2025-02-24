(function (document, $) {
  'use strict'

  var dependencies = [{primary: '_material_info_attributes_property_construction',
                       dependant: '_material_info_property_construction_other',
                       triggers: ['plot_construction_other']},
                      {primary: '_material_info_attributes_electricity_supply',
                       dependant: '_material_info_electricity_supply_other',
                       triggers: ['electricty_other']},
                      {primary: '_material_info_attributes_sewerage',
                       dependant: '_material_info_sewerage_other',
                       triggers: ['sewerage_other']},
                      {primary: '_material_info_attributes_mobile_signal',
                       dependant: '_material_info_mobile_signal_restrictions',
                       triggers: ['restricted']},
                      {primary: '_material_info_attributes_tenure',
                       dependant: '_material_info_lease_length',
                       triggers: ['leasehold']},
                      {primary: '_material_info_attributes_property_type',
                       dependant: '_material_info_floor',
                       triggers: ['apartment','duplex','maisonette','studio']}]

  var validations = [{primary: '_material_info_attributes_mprn',
                      regex: '^[0-9]{6,11}$',
                      info: 'must be 6 to 11 digits'},
                     {primary: '_material_info_attributes_mpan',
                      regex: '^[0-9]{13,13}$',
                      info: 'must be 13 digits'}]

  var classes = ['plot', 'development'] 

  document.addEventListener('turbolinks:load', function (event) {

    if ($('#metadata').length == 0) { return }

    $('.tabspan').each(function(tab) {
      $(this).on('click', function (event) {
        tab_selected($(this).parent())
      })
    })

    create_dependencies(dependencies).forEach(function(dependency) {
      $(dependency.primary).selectmenu({
        select: function (event, ui) {
          check_dependency(dependency)
        }
      })
      check_dependency(dependency)
    })

    classes.forEach(function (c, index) {
      validations.forEach(function (v, vindex) {
        create_validation($('#' + c + v.primary), v.regex, v.info)
      })
    })

    tab_selected($('.tab').first())
  })

  function create_validation(field, regex, info) {
    field.on( 'keyup paste', function() {
    // $(document).on('keyup paste', field, function (event) {
      var condition = new RegExp(regex)
      if (field.val() == '' || condition.test(field.val())) {
        field.closest('div').removeClass('field_with_errors')
        if (field.next().prop('nodeName') == 'SPAN') {
          field.next().remove()
        }
      } else {
        field.closest('div').addClass('field_with_errors')
        if (field.next().prop('nodeName') != 'SPAN') {
          field.after("<SPAN class='error'>" + info + "</SPAN>")
        }
      }

      check_submit()
    })
  }

  function check_submit() {
    $('.btn-form-submit').prop('disabled', ($('.error').length != 0));
  }

  function check_dependency(dependency) {
    $(dependency.dependant).toggle(jQuery.inArray($(dependency.primary).val(), dependency.triggers) !== -1)
  }

  function tab_selected(selected_tab) {
    $('.tab').each(function(tab) {
      $(this).children(":first").toggleClass("active", $(this).is(selected_tab));
      $("div#".concat($(this).attr('id'))).toggle($(this).is(selected_tab))
    })
  }

  function create_dependencies(dependencies) {
    var mi_dependencies = []

    dependencies.forEach(function(dependency) {
      classes.forEach(function (c, index) {
        mi_dependencies.push(
        {
          primary: '#'.concat(c).concat(dependency.primary),
          dependant: '.'.concat(c).concat(dependency.dependant),
          triggers: dependency.triggers
        })
      });
    })

    return mi_dependencies
  }

})(document, window.jQuery)