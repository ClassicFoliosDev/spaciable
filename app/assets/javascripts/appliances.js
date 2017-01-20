$(document).on('click', '.appliances .ui-menu-item', function (event) {

  var option_name = this.innerText;
  var $select_container = $(this).closest(".select-container");

    if ($select_container.length > 0) {
    var list_name = $select_container[0].classList;
    var $parent_fieldset = $select_container.closest("fieldset");

    if (list_name.contains("appliance-category")) {

      var $manufacturer_div = $parent_fieldset.find(".manufacturer");
      var $manufacturer_select = clearFields($manufacturer_div);

      var url = "/appliance_manufacturers";
      setFields($manufacturer_select, url, { option_name: option_name });
    }
  }
});
