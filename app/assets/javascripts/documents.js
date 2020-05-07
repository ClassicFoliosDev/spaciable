// hide the Guide selector if the Category selector does not have value my_home on selection Category option
$(document).on('click', '#document_category-menu', function (event) {
  if ($('#documentCategorySelector').find('option[value=my_home]')[0].selected) {
    $('#documentGuideSelector').show()
  } else {
    $('#documentGuideSelector option')[0].selected = true
    $('#documentGuideSelector').hide()
  }
})

// hide the Guide selector if the Category selector does not have value my_home on page load
document.addEventListener('turbolinks:load', function (event) {
  if ($('#documentCategorySelector').length) {
    if ($('#documentCategorySelector').find('option[value=my_home]')[0].selected) {
      $('#documentGuideSelector').show()
    } else {
      $('#documentGuideSelector').hide()
    }
  }
})
