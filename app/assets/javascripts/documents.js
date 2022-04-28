var category = '#documentCategorySelector'
var guide = '#documentGuideSelector'
var doc_title = '#document_title'

// show or hide the guide selector on category change
$(document).on('click', '#document_category-menu', function (event) {
  multipleFilesCategorySelection()
})

// show or hide the guide selector when selecting documents for upload
$(document).on('change', '#document_files.file-upload', function (event) {
  multipleFilesCategorySelection()
})

// hide the Guide selector if the Category selector does not have value my_home on page load
document.addEventListener('turbolinks:load', function (event) {
  if ($(category).length) {
    if ($(category).find('option[value=my_home]')[0].selected) {
      $(guide).show()
    } else {
      $(guide).hide()
      resetGuide()
    }
  }

  $("#document_guide").selectmenu({
    select: function (event, ui) {
      if($("#document_guide").val() != "") { $("#document_override").prop("checked", true) }
    }
  })
})

// check for multiple documents and selected category
function multipleFilesCategorySelection () {
  if ($(guide).length) {
    if ($(category).find('option[value=my_home]')[0].selected &&
       (($('.single-file-upload').length) || ($('#document_files.file-upload')[0].files.length <= 1))) {
      $(guide).show()
    } else {
      $(guide).hide()
      resetGuide()
    }
  }

  $(doc_title).prop('disabled', ($('#document_files.file-upload')[0].files.length > 1))
  if ($('#document_files.file-upload')[0].files.length > 1) { $(doc_title).val("") }
}

// reset the guide and dropdown value
function resetGuide () {
  $('#documentGuideSelector select')[0].selectedIndex = 0
  $('#documentGuideSelector .ui-selectmenu-text')[0].innerHTML = "&nbsp;"
}
