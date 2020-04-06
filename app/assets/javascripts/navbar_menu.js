(function (document, $) {
  'use strict'

  // make the dropdown menu the same width as the name element
  document.addEventListener('turbolinks:load', function () {
    var menuItem = document.getElementById("acctNav")
    var navList = document.getElementById("navList")

    var menuWidth = window.getComputedStyle(menuItem, null).getPropertyValue("width")
    navList.style.width = menuWidth

    // if tablet or mobile view then change the fa
    if ($(window).innerWidth() < 1025) {
      var arrow = document.getElementById("upDownArrow")
      arrow.classList = "fa fa-user-circle-o"
    }
  })

  // toggle the dropdown menu open and closed
  $(document).on('click', '#acctNav', function (event) {
    $('#navList').toggle()
    // toggle the fa arrow up or down depending on if the dropdown menu is open or closed
    var dropdown = document.getElementById("dropdownMenu")
    dropdown.classList.toggle("active")
    var arrow = document.getElementById("upDownArrow")
    if (dropdown.classList.contains("active")) {
      arrow.classList.add("fa-angle-up")
      arrow.classList.remove("fa-angle-down")
    } else {
      arrow.classList.add("fa-angle-down")
      arrow.classList.remove("fa-angle-up")
    }
  })

  // change the dropdown menu for mobile view


  // open the main navigation
  $(document).on('click', '.navbar-trigger-label', function (event) {
    $('.navbar-menu').animate({width: 'toggle'})
    $("body").toggleClass("no-scroll")
    if ($(window).innerWidth() < 1025) {
      $('.menu-text').hide()
    } else {
      $('.menu-text').toggle()
    }
  })

  $(document).on('click', '.admin-trigger-label', function (event) {
    $('.navbar').toggle()
    $('.main-container').toggle()
  })

  $(document).on('click', '.navbar-link', function (event) {
    if ($(this).css('padding') === '20px') {
      $('.navbar').toggle()
      $('.main-container').toggle()
    }
  })
})(document, window.jQuery)

