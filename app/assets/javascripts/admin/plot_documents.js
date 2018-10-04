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

$(document).on('change', '#document_file', function () {
  var filename = this.value
  var index = filename.lastIndexOf('\\')
  if (index >= 0) { filename = filename.substring(index + 1) }
  index = filename.indexOf('.')
  if (index > 0) { filename = filename.substring(0, index) }

  console.log(filename)
  $('.document_title').find('input')[0].value = filename
})
