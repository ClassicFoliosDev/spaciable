(function (document, $) {
  'use strict'

  var slideIndex = 0
  carousel()

  function carousel () {
    var $slides = $(document).find('.carousel')

    for (var i = 0; i < $slides.length; i++) {
      $slides[i].style.display = 'none'
    }

    var $slide = $('.img' + slideIndex)
    if ($slide) {
      $slide.fadeIn(2000)
    }
    slideIndex++
    if (slideIndex >= $slides.length) {
      slideIndex = 0
    }
    setTimeout(carousel, 15000) // Wait time in milliseconds
  }

  $(document).on('click', '.accept-ts-and-cs', function (event) {
    $('.continue').prop('disabled', this.checked ? false : 'disabled')
  })
})(document, window.jQuery)
