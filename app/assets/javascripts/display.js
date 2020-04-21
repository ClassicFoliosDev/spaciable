(function (document, $) {
  'use strict'

  // update the branded body min height -> min height is window height minus hero
  document.addEventListener('turbolinks:load', function () {
      var content = document.querySelector(".branded-body")

      var hero = document.querySelector(".branded-hero")
      var heroHeight = hero.offsetTop + hero.offsetHeight

      content.style.minHeight = window.innerHeight - heroHeight
  })

})(document, window.jQuery)
