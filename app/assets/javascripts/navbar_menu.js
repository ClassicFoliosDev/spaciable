(function (document, $) {
  'use strict'

  document.addEventListener('turbolinks:load', function () {
    if ($('#navList').length) {
      // make the dropdown menu the same width as the name element (desktop only)
      var menuItem = document.getElementById("acctNav")
      $("#navList").css("width", window.getComputedStyle(menuItem, null).width)

      // hide the plot address (desktop only)
      $("#hiddenAddress").css("display", "none")
    }
  })

  // open the search bar on tablet and mobile
  $(document).on('click touchstart', '#lowerSearchLink', function (event) {
    $('#lowerSearch').toggle()
    // disable body scrolling
    $("body").toggleClass("no-scroll")
  })

  // change the dropdown menu for mobile view
  document.addEventListener('turbolinks:load', function () {
    if ($(window).innerWidth() < 1025) {
      // change the account navigation icon
      var arrow = document.querySelector("#upDownArrow")
      arrow.classList = "fa fa-user-circle-o"
      // set the dropdown width to 100%
      $("#navList").css("width", "100%")
      // remove header search element
      $(".navbar-search .search-container").remove()
    } else {
      $(".lower-navigation .lower-navbar-search").remove()
    }
  })

  // toggle the dropdown menu open and closed
  $(document).on('click', '#acctNav', function (event) {
    $('#navList').toggle()
    // toggle the fa arrow up or down depending on if the dropdown menu is open or closed
    $("#dropdownMenu").toggleClass("active")
    if ($("#dropdownMenu").hasClass("active")) {
      $("#upDownArrow").addClass("fa-angle-up")
      $("#upDownArrow").removeClass("fa-angle-down")
    } else {
      $("#upDownArrow").removeClass("fa-angle-up")
      $("#upDownArrow").addClass("fa-angle-down")
    }
  })

  // mobile view account dropdown alterations
  $(document).on('click', '.dropdown', function (event) {
    if ($(window).innerWidth() < 1025) {
      // hide the logo and hamburger navigation
      $("#topNav").toggleClass("dropdown-active")
      // disable body scrolling
      $("body").toggleClass("no-scroll")
      // show address
      $("#hiddenAddress").css("display", "block")
      // show sign out arrow
      $('.sign-out-arrow').toggle()
    }
  })

  // repair styling/functionality when account dropdown closed via click anywhere
  $(document).on('click', '#navList', function (event) {
    // show hamburger navigation
    $("#topNav").removeClass("dropdown-active")
    // allow body scrolling
    $("body").removeClass("no-scroll")
  })

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
