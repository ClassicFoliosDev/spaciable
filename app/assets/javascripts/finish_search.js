/* global $, clearFields, setFields */
var $finish_filter_cookie = "finish-filter-open"

document.addEventListener('turbolinks:load', function () {

  finishFilterForm = $(".new_finish_filter")
  if (finishFilterForm.length == 0) { return }

  if (getCookie($finish_filter_cookie) != "true") {
    toggleFinishFilter()
  }

  controls = [
    $('.finish_filter_finish_category_id select'),
    $('.finish_filter_finish_type_id select'),
    $('.finish_filter_finish_manufacturer_id select')
  ];

  for (i = 0; i < controls.length; ++i) {
    controls[i].selectmenu({
      select: function (event, ui) {
        window.location = finishFilterForm.attr('action') + '?' + finishFilterForm.serialize()
      }
    })
  }
})

$(document).on('click', '.finish-filter .collapse .fa', function () {
  toggleFinishFilter()
})

$(document).on('click', '.finish-filter-selections .collapse .fa', function () {
  toggleFinishFilter()
})

function toggleFinishFilter() {
  setCookie($finish_filter_cookie, $(".finish-filter-selections").is(":visible"), 2000)
  $(".finish-filter").toggle()
  $(".finish-filter-selections").toggle()
  displayFinishFilterSelections()
}

function displayFinishFilterSelections() {
  if (getCookie($finish_filter_cookie) != "true") {
    $(".filter-selections").html(
      "<label>Finish Category: </label> <span>" + $("#finish_filter_finish_category_id option:selected").text() + "</span><br/>" +
      "<label>Finish Type: </label> <span>" + $("#finish_filter_finish_type_id option:selected").text() + "</span><br/>" +
      "<label>Finish Manufacturer: </label> <span>" +$("#finish_filter_finish_manufacturer_id option:selected").text() + "</span><br/>"
    )
  }
}
