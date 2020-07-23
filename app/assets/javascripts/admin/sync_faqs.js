$(document).on('click', '.select-all', function (event) {
  var category = $(this).data().category
  $(".faq_" + category).each(function() {
    var faq = ($(this).find("input"))
    faq.each(function () {
      console.log(faq[0].checked = true)
    })
  })
})

$(document).on('click', '.deselect-all', function (event) {
  var category = $(this).data().category
  $(".faq_" + category).each(function() {
    var faq = ($(this).find("input"))
    faq.each(function () {
      console.log(faq[0].checked = false)
    })
  })
})