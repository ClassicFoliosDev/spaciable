// hide the Guide selector if the Category selector does not have value my_home
$(document).on('click', '#document_category-menu', function (event) {
  if ($('#documentCategorySelector').find('option[value=my_home]')[0].selected) {
    $('#documentGuideSelector').show()
  } else {
    $('#documentGuideSelector option')[0].selected = true
    $('#documentGuideSelector').hide()
  }
})
