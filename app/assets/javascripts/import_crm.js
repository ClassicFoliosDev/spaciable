$(document).on('change keyup paste', '#select_import_plots_list', function (event) {
  $(".plot-buttons :input").each(function() {
    $(this).prop('disabled', event.target.textLength == 0)
  })
});
