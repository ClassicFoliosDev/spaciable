/* global $ */

$(document).on('change', '.update', function (event) {
  const $input = $(event.target)
  const $form = $input.closest('form')
  const method = $('input[name="_method"]').val()

  console.log(method)
  const params = buildParams($input, $form)

  var url = $form.attr("action")

  console.log($input)
  console.log(url)

  $.ajax({
    url: url,
    method: method,
    dataType: 'json',
    data: params,
    success: function (response) {
      var $flash = $('.flash')
      $flash.empty()

      var $notice = document.createElement('p')
      $notice.className = 'notice'
      $notice.innerHTML = response.notice
      $flash.append($notice)
    },
    error: function (response) {
      var $flash = $('.flash')
      $flash.empty()
      var $notice = document.createElement('p')
      $notice.className = 'alert'
      console.log(response)
      $notice.innerHTML = response.errors
      $flash.append($notice)
    }
  })
})


function buildParams ($input, $form) {
  const inputNameParts = ($input.attr('name')).split('[');
  const token = $('input[name="authenticity_token"]', $form).val();

  var modelName = inputNameParts[0]
  var methodName = inputNameParts[1].replace("]", "")

  const params = {
    authenticity_token: token,
    [modelName]: {
      [methodName]: $input.val()
    },
    client: true
  };

  return params;
}
