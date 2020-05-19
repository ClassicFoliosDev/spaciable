/* global $ */

var plotCat = '#plotDocCategorySelector'
var plotGuide = '#plotDocGuideSelector'

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
  if ($(plotGuide).length) {
    if ($(plotCat).find('option[value=my_home]')[0].selected) {
      $(plotGuide).show()
    } else {
      $(plotGuide).hide()
      resetPlotGuide()
    }
  }
})

function resetPlotGuide () {
  $('#plotDocGuideSelector select')[0].selectedIndex = 0
  $('#plotDocGuideSelector .ui-selectmenu-text')[0].innerHTML = "&nbsp;"
}
