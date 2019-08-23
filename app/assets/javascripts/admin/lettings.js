(function (document, $) {
  'use strict'

  $(document).on('change', '.letting-radio', function (event) {
    if(document.getElementById('lettings_admin_checked').checked) {
      $('.admin-letting-options').show()
      $('.homeowner-letting-options').hide()
      $('.not-lettable-letting-options').hide()
    }
    else if (document.getElementById('lettings_homeowner_checked').checked) {
      $('.homeowner-letting-options').show()
      $('.admin-letting-options').hide()
      $('.not-lettable-letting-options').hide()

    }
    else {
      $('.not-lettable-letting-options').show()
      $('.homeowner-letting-options').hide()
      $('.admin-letting-options').hide()
    }
  })

  function removeElement(elementID) {
    var element = document.getElementById(elementID)
    elementID.parentNode.removeChild(elementID)
  }

})(document, window.jQuery)
