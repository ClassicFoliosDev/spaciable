/* global $, clearFields, setFields */

document.addEventListener('turbolinks:load', function () {
  $developerSelect = $('.visits_developer_id select')
  if ($developerSelect.length == 0) { return }

  $divisionSelect = $('.visits_division_id select')
  $developmentSelect = $('.visits_development_id select')
  $businessSelect = $('.visits_business select')

  $(".visits_start_date").change(function(){
    filter_visits()
  });

  $(".visits_end_date").change(function(){
    filter_visits()
  });

  if ($developerSelect.find('option:selected').attr('value') == "") {
    $('.visits_division_id, .visits_development_id').hide()
  }

  $developerSelect.selectmenu({
    select: function (event, ui) {
      $divisionSelect.val('')
      $developmentSelect.val('')
      filter_visits()
    }
  })

  $divisionSelect.selectmenu({
    select: function (event, ui) {
      $developmentSelect.val('')
      filter_visits()
    }
  })

  $developmentSelect.selectmenu({
    select: function (event, ui) {
      filter_visits()
    }
  })

  $businessSelect.selectmenu({
    select: function (event, ui) {
      filter_visits()
    }
  })
})

function filter_visits() {
  if (moment($("#visits_end_date").val()) <
      moment($("#visits_start_date").val())) {
    flash_alert("End date must be after start date")
  } else if (moment($("#visits_start_date").val()) < moment("2020-10-02")){
    flash_alert("Earliest available start date is 02/10/2020")
  } else {
    var form = $('.simple_form.visits')
    window.location =  form.attr('action') + '?' + form.serialize()
  }
}
