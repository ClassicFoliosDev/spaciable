function flash_notice(message) {
  flash(message,'notice')
};

function flash_alert(message) {
  flash(message,'alert')
};

function flash_clear() {
  var $flash = $('.flash')
  $flash.empty()
};

function flash(message, className) {
  var $flash = $('.flash')
  $flash.empty()

  var $notice = document.createElement('p')
  $notice.className = className
  $notice.innerHTML = message
  $flash.append($notice)
};
