/* global $, clearFields, setFields */
$(document).on('click', '.how-to .ui-menu-item', function (event) {
  var optionName = this.innerText
  var $selectContainer = $(this).closest('.select-container')
  var listClasses = $selectContainer[0].classList
  var $parentFieldset = $selectContainer.closest('.how-to')

  // var category = $(document).find(".category");

  if (listClasses.contains('category')) {
    var subCategoryDiv = $parentFieldset.find('.sub-category')
    var subCategorySelect = clearFields(subCategoryDiv)

    var url = '/how_to_sub_category_list'
    setFields(subCategorySelect, url, {option_name: optionName})
  }
})
