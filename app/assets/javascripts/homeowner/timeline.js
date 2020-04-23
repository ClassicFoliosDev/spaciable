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
    // style the open/close button
    $(".shortcut-button").toggleClass("close")

    $(".shortcuts-question").toggleClass("shortcuts-grid")
    $(".shortcut-links").toggle()

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

    // add the icons to the shortcut links
    var areaGuide = document.getElementById("shortcutAreaGuide")
    var faqs = document.getElementById("shortcutFaqs")
    var howTos = document.getElementById("shortcutHowTos")
    var services = document.getElementById("shortcutServices")

    if (areaGuide) areaGuide.firstElementChild.classList = ("icon fas fa-laptop-house")
    if (faqs) faqs.firstElementChild.classList = ("icon fa fa-question")
    if (howTos) howTos.firstElementChild.classList = ("icon fa fa-book")
    if (services) services.firstElementChild.classList = ("icon fas fa-shipping-fast")
  })

  // add the fa icons to the stage tiles
  document.addEventListener('turbolinks:load', function () {
    var res = document.getElementById("iconReservation")
    var exc = document.getElementById("iconExchange")
    var mov = document.getElementById("iconMoving")
    var liv = document.getElementById("iconLiving")

    if (res) res.classList = "fa fa-check"
    if (exc) exc.classList = "fas fa-key"
    if (mov) mov.classList = "fa fa-truck"
    if (liv) liv.classList = "fas fa-male"
  })

  // display timeline in mobile view
  document.addEventListener('turbolinks:load', function () {
    if ($(window).innerWidth() < 1000) {
      var desktop = document.getElementById("timelineContentDesktop")
      var mobile = document.getElementById("timelineContentMobile")

      // add the 'timeline-content' class in mobile
      mobile.classList.add("timeline-content")

      // move all child nodes of desktop to mobile
      while(desktop.hasChildNodes()) {
        mobile.appendChild(desktop.firstChild)
      }
    }
  })

})(document, window.jQuery)
