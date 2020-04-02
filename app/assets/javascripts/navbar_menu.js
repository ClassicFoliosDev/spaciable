(function (document, $) {
  'use strict'

document.addEventListener('turbolinks:load', function () {
  var menuItem = document.getElementById("acctNav")
  var navList = document.getElementById("navList")

  var menuWidth = window.getComputedStyle(menuItem, null).getPropertyValue("width")
  navList.style.width = menuWidth
})

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

