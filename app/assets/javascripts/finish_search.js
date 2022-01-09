/* global $, clearFields, setFields */
var $finish_filter_cookie = "finish-filter-open"

document.addEventListener('turbolinks:load', function () {

  form = $(".new_finish_filter")
  if (form.length == 0) { return }

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
        window.location = form.attr('action') + '?' + form.serialize()
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

function setCookie(cname, cvalue, exdays) {
  const d = new Date();
  d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
  var expires = "expires="+d.toUTCString();
  document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

function getCookie(cname) {
  var name = cname + "=";
  var ca = document.cookie.split(';');
  for(var i = 0; i < ca.length; i++) {
    var c = ca[i];
    while (c.charAt(0) == ' ') {
      c = c.substring(1);
    }
    if (c.indexOf(name) == 0) {
      return c.substring(name.length, c.length);
    }
  }
  return "";
}
