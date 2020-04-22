(function (document, $) {
  'use strict'

  // select the radio button when clicking on the stage div and add the border
  $(document).on('click', '.timeline-stage-option', function (event) {
    this.firstElementChild.checked = true
    borderSelected()
  })

  // add or remove the 'selected' class from a timeline stage option
  function borderSelected() {
    var allStages = document.querySelectorAll('.timeline-stage-option')

    for (var i = 0; i < allStages.length; ++i) {
      if (allStages[i].firstElementChild.checked) {
        allStages[i].classList.add("selected")
      } else {
        allStages[i].classList.remove("selected")
      }
    }
  }

  // show the shortcut links
  $(document).on('click', '#timelineShortcuts', function (event) {
    $(".shortcut-links").toggle()

    // style the open/close button
    $(".shortcut-button").toggleClass("close")

    // toggle the fa icon when the button is opened/closed
    var shortcuts = document.getElementById("timelineShortcuts")
    var button = document.getElementById("shortcutButton")
    if (shortcuts.classList.contains("close")) {
      button.classList.add("fa-times")
      button.classList.remove("fa-question")
      // center the icon
      button.style.paddingLeft = "1px"
    } else {
      button.classList.add("fa-question")
      button.classList.remove("fa-times")
      button.style.paddingLeft = "0"
    }
  })

  // add the fa icons to the stage tiles
  document.addEventListener('turbolinks:load', function () {
    var res = document.getElementById("iconReservation")
    res.classList = "fa fa-check"

    var exc = document.getElementById("iconExchange")
    exc.classList = "fas fa-key"

    var mov = document.getElementById("iconMoving")
    mov.classList = "fa fa-truck"

    var liv = document.getElementById("iconLiving")
    liv.classList = "fas fa-male"
  })

})(document, window.jQuery)
