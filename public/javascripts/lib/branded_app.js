(function (document, $) {
  'use strict'
  var tabs = document.getElementsByClassName("tab")

  var tab
  for(tab of tabs) {
    if(tab.innerHTML.includes("branded_apps")) {
      tab.style.backgroundColor = "#ffcccc";
    }
  }

})(document, window.jQuery)
