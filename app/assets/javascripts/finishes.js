$(document).on('cocoon:after-insert', function(event, item) {

  // Set the CSS style classes on the selects that we've just added
  $('select').selectmenu();
});

$(document).on('click', '.ui-menu-item', function (event) {

  var option_name = this.innerText;
  var select_container = $(this).closest(".select-container");
  var list_name = select_container[0].classList;
  var parent_fieldset = select_container.closest("fieldset");

  if (list_name.contains("finish-category")) {
      var finish_type_div = parent_fieldset.find(".finish-type");
      var finish_type_select = clearFields(finish_type_div);

      var manufacturer_div = parent_fieldset.find(".manufacturer");
      clearFields(manufacturer_div);

      var url = "/update_finish_types";
      setFields(finish_type_select, url, option_name);

  } else if (list_name.contains("finish-type")) {
      var manufacturer_div = parent_fieldset.find(".manufacturer");
      var manufacturer_select = clearFields(manufacturer_div);

      var url = "/update_manufacturers";
      setFields(manufacturer_select, url, option_name);
  }
});

function clearFields(select_div) {

  // Make the options list empty
  var select_list = select_div.find("select")[0];
  select_list.options.length = 0;
  // Remove the previously-selected option name
  var prev_option = select_div.find(".ui-selectmenu-text")[0];
  prev_option.innerHTML = "&nbsp";

  return select_list;
}

function setFields(select_list, url, option_name) {
  $.getJSON({
    url: url,
    data: {
      option_name: option_name
    }
  }).done(function (results) {
    $.each(results, function (key, value) {
      var option = document.createElement("option");
      option.value = value.id;
      option.name = value.name;
      option.textContent = value.name;

      select_list.appendChild(option);
    });
  }).fail(function (response) {
    console.error("Call to " + url + " failed");
    console.log(response);
  });
}
