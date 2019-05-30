function showHideChoiceEmail(){
  element = $("#choices_email_contact")
  if (element){
    if ($("#development_choice_option").val() == "choices_disabled") {
      element.hide()
    } else {
      element.show()
    }
  }
}

$(document).ready(function(){

  var $choiceTypeSelect = $('.development_choice_option select')

  $choiceTypeSelect.selectmenu({
    select: function (event, ui) {
      showHideChoiceEmail()
    }
  })

  showHideChoiceEmail()
})

$(window).load(function(){showHideChoiceEmail()})
