$(document).on('turbolinks:load', function () {

  if($("#developer_payment").length == 0) { return }

  development.initialise()

  $(document).on('click', "#developer_payment button", function (event) {
    event.stopPropagation();
    development.developmentBilling()
  })

  $(document).on('click', "#development_payment button", function (event) {
    event.stopPropagation();
    development.developerBilling()
  })
})

var development = {
  initialise: function() {
    $("#development_specialised_codes").attr("value") == "true" ? $("#developer_payment").hide() : $("#development_payment").hide()
  },

  developmentBilling: function() {
    development.toggle()
    development.destroy("false")
    development.clone()
    $("#development_specialised_codes").attr("value", "true")
  },

  developerBilling: function() {
    development.toggle()
    development.destroy("true")
    $("#development_specialised_codes").attr("value", "false")
  },

  toggle: function() {
    $("#developer_payment").toggle()
    $("#development_payment").toggle()
  },

  destroy: function(value) {
    $( "#development_payment input" ).each(function( index ) {
      if ($(this).attr('id').endsWith("_destroy")) {
        $(this).attr('value', value)
      }
    })
  },

  clone: function() {
    $( "#development_payment input" ).each(function( index ) {
      source = '#' + $(this).attr('id').replace("development", "developer")
      if ($(source).length != 0) {
        $(this).val($(source).text())
      }
    })
  }
}
