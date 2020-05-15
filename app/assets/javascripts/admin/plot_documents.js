/* global $ */

document.addEventListener('turbolinks:load', function () {
  if ($('.plot_documents').length > 0) {
    (function () {
      $('.plot_documents .plot-select select').selectmenu({
        change: function (event, ui) {
          var $form = $(this).closest('form')

          $.post({
            url: $form.attr('action'),
            data: $form.serialize(),
            dataType: 'json'
          }).done(function (results, a, b) {
            console.log(results)
          }).fail(function (response, a, b) {
            console.log(response)
          })
        }
      })
    })()
  }
})

// show or hide the guide selector on category change
$(document).on('click', '#document_category-menu', function (event) {
  if ($('#docCategorySelector').find('option[value=my_home]')[0].selected) {
    $('#docGuideSelector').show()
  } else {
    $('#docGuideSelector').hide()
    resetGuide()
  }
})

// reset the guide and dropdown value
function resetGuide () {
  $('#docGuideSelector select')[0].selectedIndex = 0
  $('#docGuideSelector .ui-selectmenu-text')[0].innerHTML = "&nbsp;"
}