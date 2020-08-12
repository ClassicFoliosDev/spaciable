$(document).on('click', '.category-select-all', function (event) {
  var category = $(this).data().category
  $(".faq_" + category).each(function() {
    var faq = ($(this).find("input"))
    faq.each(function () {
      if (!faq[0].disabled) {
        faq[0].checked = true
      }
    })
  })
})

$(document).on('click', '.category-deselect-all', function (event) {
  var category = $(this).data().category
  $(".faq_" + category).each(function() {
    var faq = ($(this).find("input"))
    faq.each(function () {
      faq[0].checked = false
    })
  })
})

$(document).on('click', '.select-all', function (event) {
  $(".faq-selector").each(function() {
    var faq = ($(this).find("input"))
    faq.each(function () {
      if (!faq[0].disabled) {
        faq[0].checked = true
      }
    })
  })
})

$(document).on('click', '.deselect-all', function (event) {
  $(".faq-selector").each(function() {
    var faq = ($(this).find("input"))
    faq.each(function () {
      faq[0].checked = false
    })
  })
})

$(document).on('click', '.compare-btn', function (event) {
  event.preventDefault()
  var faq = $(this).data().id
  $(".faq_compare_" + faq).show()
  $(".compare_" + faq).hide()
  $(".hide_" + faq).show()
})

$(document).on('click', '.hide-btn', function (event) {
  event.preventDefault()
  var faq = $(this).data().id
  $(".faq_compare_" + faq).hide()
  $(".hide_" + faq).hide()
  $(".compare_" + faq).show()
})