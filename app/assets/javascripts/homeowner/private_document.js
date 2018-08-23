(function (document, $) {
  'use strict'

  $(document).on('change', '.upload-document', function (event) {
    $('.new_private_document').submit()
  })
})(document, window.jQuery)
