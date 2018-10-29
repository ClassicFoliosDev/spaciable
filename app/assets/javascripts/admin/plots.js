(function (document, $) {
  'use strict'

  $(document).on('change', '#plot_copy_plot_numbers, #phase_bulk_edit_copy_plot_numbers', function (event) {
    if (this.checked) {
      $('#plot_house_number').prop('disabled', true)
      $('#phase_bulk_edit_house_number').prop('disabled', true)
    } else {
      $('#plot_house_number').prop('disabled', false)
      $('#phase_bulk_edit_house_number').prop('disabled', false)
    }
  })
})(document, window.jQuery)
