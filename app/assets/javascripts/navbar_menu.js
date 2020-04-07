(function (document, $) {
  'use strict'

    document.addEventListener('turbolinks:load', function () {
    // make the dropdown menu the same width as the name element (desktop only)
    var menuItem = document.getElementById("acctNav")
    var navList = document.getElementById("navList")

    var menuWidth = window.getComputedStyle(menuItem, null).getPropertyValue("width")
    navList.style.width = menuWidth

    // hide the plot address (desktop only)
    var address = document.getElementById("hiddenAddress")
    address.style.display = "none"
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
  document.addEventListener('turbolinks:load', function () {
    if ($(window).innerWidth() < 1025) {
      // change the account navigation icon
      var arrow = document.getElementById("upDownArrow")
      arrow.classList = "fa fa-user-circle-o"
      // set the dropdown width to 100%
      var navList = document.getElementById("navList")
      navList.style.width = "100%"
      // remove header search element
      var topNav = document.getElementById("topNav")
      var search = topNav.querySelector(".search-container")
      search.parentNode.removeChild(search)
    }
  })

  // mobile view account dropdown alterations
  $(document).on('click', '.dropdown', function (event) {
    if ($(window).innerWidth() < 1025) {
      // hide the logo and hamburger navigation
      var nav = document.getElementById("topNav")
      nav.classList.toggle("dropdown-active")
      // disable body scrolling
      $("body").toggleClass("no-scroll")
      // show address
      var address = document.getElementById("hiddenAddress")
      address.style.display = "block"
      // add fa to sign out
      var signOut = document.querySelector("#signOut")
      var faIcon = document.createElement('i')
      faIcon.classList = "branded-secondary fa fa-angle-left"
      signOut.insertBefore(faIcon, signOut.childNodes[0])
    }
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
