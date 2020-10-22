$(document).on('click', '#add_timeline_plots', function (event) {
  var plots = []
  $("#phase_timeline_plot_ids option").each(function( index ) {
    plots.push($(this).val())
  })
  $("#phase_timeline_plot_ids").val(plots).trigger("change")
})

$(document).on('click', '#clear_timeline_plots', function (event) {
  $("#phase_timeline_plot_ids").val(null).trigger("change")
})

$(document).on('click', '#submit_phase_timeline', function (event) {
  pt.confirm()
})

var pt = {
    confirm: function(){
      if ($("#phase_timeline_timeline_id").children("option:selected").text() !=
          $("#phase_timeline_timeline_id").attr("orig_timeline")) {

        dialog_body = '<h3>Replace Timeline Allocation</h3>' +
            '<div>' +
              '<p>All associated plots will have their timeline progress destroyed and reset to the beginning of the newly allocated timeline.  Are you sure you want to continue?</p>' +
            '</div>' +
            '<div>' +
              '<p>Current Timeline: ' + $("#phase_timeline_timeline_id").attr("orig_timeline") + '</p>' +
              '<p>New Timeline: ' + $("#phase_timeline_timeline_id").children("option:selected").text()  + '</p>' +
              '<p>Plots: ' + pt.plots() + '</p>' + '</div>'

        var $dialogContainer = $('<div>', { id: 'dialog', class: 'feedback-dialog' })
          .html(dialog_body)

        // Display the modal dialog and ask for confirm/cancel
        $(document.body).append($dialogContainer)

        $dialogContainer.dialog({
          show: 'show',
          modal: true,
          dialogClass: 'archive-dialog',
          buttons: [
            {
              text: "Cancel",
              class: 'btn-secondary',
              click: function () {
                $(this).dialog('close')
                $(this).dialog('destroy').remove()
              }
            },
            {
              text: "Confirm",
              class: 'btn-primary',
              id: 'btn_confirm',
              click: function () {
                pt.submit()
              }
            }]
        }).prev().find('.ui-dialog-titlebar-close').hide()
      }
      else {
        pt.submit()
      }
    },

    plots: function(){
      return $("#phase_timeline_plot_ids :selected").text().replace(/Plot /g,',').substring(1)
    },

    submit: function(){
      $.post($(".edit_phase_timeline").attr("action"), $(".edit_phase_timeline").serialize())
    }
}


