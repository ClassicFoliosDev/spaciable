var $page_dirty = false

$(document).ready(function() {

  window.addEventListener('beforeunload', function(e) {
    if($page_dirty) {
      //following two lines will cause the browser to ask the user if they
      //want to leave. The text of this dialog is controlled by the browser.
      e.preventDefault(); //per the standard
      e.returnValue = ''; //required for Chrome
    }
    //else: user is allowed to leave without a warning dialog
  })
})
