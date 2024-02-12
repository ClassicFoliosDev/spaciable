document.addEventListener('turbolinks:load', function () {

   cpp = $("#phase_cpp")

  $("#phase_package").selectmenu({
    select: function (event, ui) {
      cpp.val(cpps[event.target.value])
      cpp.trigger('change')
    }
  })

  cpp.change(function() {
    to_two($(this))
  });

  cpp.on('keyup', function (e) {
    if (e.key === 'Enter' || e.keyCode === 13) {
      to_two($(this))
    }
  });

  function to_two(field) {
    field.val(parseFloat(field.val()).toFixed(2));
  }

  to_two(cpp)
})