(function (document, $) {
  'use strict'

  $(document).on('change', '#plot_copy_plot_numbers', function (event) {
    console.log(this.checked)
    if (this.checked) {
      $('#plot_house_number').prop('disabled', true)
    } else {
      $('#plot_house_number').prop('disabled', false)
    }
  })
})(document, window.jQuery)
