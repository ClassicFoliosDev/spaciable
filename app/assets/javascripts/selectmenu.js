/* global $ */
document.addEventListener('turbolinks:load', function () {
  $('select').not('.skip-global-selectmenu select').selectmenu()
})
