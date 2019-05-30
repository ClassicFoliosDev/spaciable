/* global $ */

$(document).ready(function(){
  var $configPhases = $('.phases')

  if ($configPhases.length > 0) {
    var phaseAnchor = window.location.hash
    var $phase = $(phaseAnchor)
    var phaseIndex = $configPhases.find('dt').index($phase)

    if (phaseIndex > -1) {
      $configPhases.accordion({active: phaseIndex, heightStyle: 'content'})
      $('body').scrollTop($phase.position().top)
    } else {
      $configPhases.accordion({heightStyle: 'content'})
    }
  }

  $(".chosen-select").attr("data-placeholder", "Select plots..")
  $(".chosen-select").chosen({width: "100%"})

  class PhasePlotList {
    constructor(button) {
      button.addEventListener("click", this.addAllPlots);
    }

    addAllPlots(action) {
      var listname = '#'+action.currentTarget.getAttribute('data-select')
      $(listname+' option').prop('selected', true).trigger('chosen:updated');
    }
  }

  var PhasePlotLists = [];
  buttons = $('button[id^=Select_all_phase_][id$=_plots]')
  for(i = 0;i < buttons.length; i++) {
    PhasePlotLists.push(new PhasePlotList(buttons[i]))
  }

  $('span[id^=choice_configuration_phase_][id$=_ids-button]').css("display", "none");
})

$(window).load(function(){
  $('span[id^=choice_configuration_phase_][id$=_ids-button]').css("display", "none");
})

