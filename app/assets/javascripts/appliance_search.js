/* global $, clearFields, setFields */
var $appliance_filter_cookie = "appliance-filter-open"

document.addEventListener('turbolinks:load', function () {

  applianceFilterForm = $(".new_appliance_filter")
  if (applianceFilterForm.length == 0) { return }

  if (getCookie($appliance_filter_cookie) != "true") {
    toggleapplianceFilter()
  }

  controls = [
    $('.appliance_filter_appliance_category_id select'),
    $('.appliance_filter_appliance_manufacturer_id select')
  ];

  for (i = 0; i < controls.length; ++i) {
    controls[i].selectmenu({
      select: function (event, ui) {
        window.location = applianceFilterForm.attr('action') + '?' + applianceFilterForm.serialize()
      }
    })
  }
})

$(document).on('click', '.appliance-filter .collapse .fa', function () {
  toggleapplianceFilter()
})

$(document).on('click', '.appliance-filter-selections .collapse .fa', function () {
  toggleapplianceFilter()
})

function toggleapplianceFilter() {
  setCookie($appliance_filter_cookie, $(".appliance-filter-selections").is(":visible"), 2000)
  $(".appliance-filter").toggle()
  $(".appliance-filter-selections").toggle()
  displayapplianceFilterSelections()
}

function displayapplianceFilterSelections() {
  if (getCookie($appliance_filter_cookie) != "true") {
    $(".filter-selections").html(
      "<label>appliance Category: </label> <span>" + $("#appliance_filter_appliance_category_id option:selected").text() + "</span><br/>" +
      "<label>appliance Manufacturer: </label> <span>" +$("#appliance_filter_appliance_manufacturer_id option:selected").text() + "</span><br/>"
    )
  }
}
