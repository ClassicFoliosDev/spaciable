/* global $ */

$(document).on('change', ".update", event => {
  const $input = $(event.target);
  const $form = $input.closest('form');
  const method = $('input[name="_method"]').val();
  const params = buildParams($input, $form);

  $.ajax({
    url: $form.attr('action'),
    method: method,
    dataType: 'json',
    data: params,
    success: function(response) {
      var $flash = $('.flash');
      $flash.empty();

      updateResults(response);

      var $notice = document.createElement('p');
      $notice.className = 'notice';
      $notice.innerHTML = response.notice;
      $flash.append($notice);
    },
    error: function(response) {
      var $flash = $('.flash');
      $flash.empty();
      var $notice = document.createElement('p');
      $notice.className = 'alert';
      $notice.innerHTML = response.responseJSON['error'];
      $flash.append($notice);
    }
  });
});
