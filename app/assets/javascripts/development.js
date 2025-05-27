
var fixflow_billing = '#fixflow_billing'
var fixflow_direct = '#development_maintenance_attributes_fixflow_direct'

document.addEventListener('turbolinks:load', function () {
  if ($(fixflow_billing).length == 0) { return }

  fixflow.show_hide()
})

// show or hide the fixflow direct billing on selection of a maintainance option
$(document).on('click', '#development_maintenance_attributes_account_type-menu', function (event) {
  fixflow.show_hide()
})

var fixflow = {
  $documents: "",
  $currentPlot: "",
  $checked_documents: "",

  show_hide: function() {
    selection = $('#development_maintenance_attributes_account_type').val()
    if (selection == 'standard' || selection == "full_works") {
      $(fixflow_billing).show()
    } else {
      $(fixflow_billing).hide()
      $( "#development_maintenance_attributes_fixflow_direct" ).prop( "checked", false );
    }
  }
}

