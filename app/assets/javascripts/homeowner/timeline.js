(function (document, $) {
  'use strict'

  // select the radio button when clicking on the stage div
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
