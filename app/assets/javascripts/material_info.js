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

  var checks = [{datum: '#development_material_info_attributes_service_charges', 
                 label: 'div.development_material_info_service_charges label'},
                {datum: '#development_material_info_attributes_council_tax_band', 
                 label: 'div.development_material_info_council_tax_band label'},
                {datum: '#development_material_info_attributes_epc_rating', 
                 label: 'div.development_material_info_epc_rating label'}
               ]

  document.addEventListener('turbolinks:load', function (event) {

    if ($('#metadata').length == 0) { return }

    if ($('div#primary').length == 0 ) { 
      $('li#primary').remove()
      $('li#details span').addClass('active')
    }

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

    // If there are associated plots with material info
    if ($('.ut-update-option-form').length != 0) { 
      // Add on onClick handler for the submit button
      hijack_development_submit()
      //document.getElementsByClassName('btn-form-submit')[0].addEventListener("click", CheckMaterialInfoChanges);
      set_initial_mi_data() 
    }

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

  function hijack_development_submit() {
    $(".edit_development").on('submit', function(e) {
      // what has been submitted?
      set_submit_mi_data()

      // If anything has changed
      if (mi_data_updated()) {
        ConfirmMaterialInfoPropogation()
        e.preventDefault();
        e.returnValue = false;
      }
    })
  }

  function set_initial_mi_data() {
    checks.forEach(function (c, index) {
      c.initial_value = $(c.datum).val()
    })
  }

  function set_submit_mi_data() {
    checks.forEach(function (c, index) {
      c.submit_value = $(c.datum).val()
    })
  }

  function mi_data_updated() {
    var delta = ''
    var updates = []
    checks.forEach(function (c, index) {
      if (c.submit_value != c.initial_value) { updates.push(c) }
    })
    updates.forEach(function (c, index) {
      delta = delta.concat($(c.label).text())
      if (index != (updates.length - 1)) { // ignore the last
        delta = delta.concat('/')
      }
    })

    if (updates.length == 1) { 
      delta = "You have requested a change to ".concat(delta).concat(". Would you like to make this change across all existing plots?")
      $('#ut_confirm').text("If this change doesn’t apply to all existing plots, you will need to make individual changes at plot level.")
    } else if (updates.length > 1) { 
      delta = "You have requested changes to ".concat(delta).concat(". Would you like to make these across all existing plots?")
      $('#ut_confirm').text("If these changes don't apply to all existing plots, you will need to make individual changes at plot level.")
    }

    $('#ut_header').text(delta)

    return delta.length != 0
  }

  function ConfirmMaterialInfoPropogation() {
    var $option_container = $('.ut-update-option-form')
    $('body').append($option_container)

    $option_container.dialog({
      show: 'show',
      modal: true,
      width: 800,
      title: "Change Details",
      buttons: [
        {
          text: "Yes – change all plots",
          class: 'btn-primary',
          id: 'btn_confirm',
          click: function () {
            $('#development_material_info_attributes_proliferate').val('1')
            SubmitDevelopment()
            $(this).dialog('close')
            $(this).dialog('destroy').remove()
          }
        },
        {
          text: "No – change at development level for future plots",
          class: 'btn',
          id: 'btn_deny',
          click: function () {
            SubmitDevelopment()
            $(this).dialog('close')
            $(this).dialog('destroy').remove()
          }
        },
        {
          text: "Cancel – discard all changes",
          class: 'btn',
          click: function () {
            $(this).dialog('destroy')
          }
        }]
    }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
  }

  function SubmitDevelopment(){
    var x = document.getElementsByClassName("edit_development");
    x[0].submit(); // Form submission
  }

})(document, window.jQuery)