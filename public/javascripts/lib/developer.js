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

function showHideConstructionName(){
  element = $("#construction_name")
  if (element){
    if ($("#development_construction").val() == "residential") {
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

$(document).ready(function(){
  var $constructionTypeSelect = $('.development_construction select')

  $constructionTypeSelect.selectmenu({
    select: function (event, ui) {
      showHideConstructionName()
    }
  })
  showHideConstructionName()
})
$(window).load(function(){showHideConstructionName()})
