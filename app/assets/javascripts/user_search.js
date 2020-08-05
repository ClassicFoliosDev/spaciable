/* global $, clearFields, setFields */

document.addEventListener('turbolinks:load', function () {
  $developerSelect = $('.user_search_developer_id select')
  if ($developerSelect.length == 0) { return }

  $divisionSelect = $('.user_search_division_id select')
  $developmentSelect = $('.user_search_development_id select')
  $roleSelect = $('.user_search_role select')

  if ($developerSelect.find('option:selected').attr('value') == "") {
    $('.user_search_division_id, .user_search_development_id').hide()
  }

  $developerSelect.selectmenu({
    select: function (event, ui) {
      $divisionSelect.val('')
      $developmentSelect.val('')
      filter_search()
    }
  })

  $divisionSelect.selectmenu({
    select: function (event, ui) {
      $developmentSelect.val('')
      filter_search()
    }
  })

  $developmentSelect.selectmenu({
    select: function (event, ui) {
      filter_search()
    }
  })

  $roleSelect.selectmenu({
    select: function (event, ui) {
      filter_search()
    }
  })
})

function filter_search() {
  var form = $('.new_user_search')
  window.location =  form.attr('action') + '?' + form.serialize()
}
