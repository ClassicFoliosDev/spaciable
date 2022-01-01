/* global $, clearFields, setFields */

$(document).on('turbolinks:load', function () {

  if ($(".current").text() != 'Release plots' ) { return }

  // Add on onClick handler for the submit button
  $("#submit" ).on( "click", function() { release.validate() })
})

var release = {

  // Extract the data fields from the form
  formData: function (){

    json = {};
    json.list = $('#phase_release_plots_list')[0].value
    json.order_number = $('#phase_release_plots_order_number')[0].value
    json.release_type = $('#release_type')[0].value
    json.release_date = $('#phase_release_plots_release_date')[0].value
    json.validity = $('#phase_release_plots_validity')[0].value
    json.extended = $('#phase_release_plots_extended_access')[0].value
    json.send_to_admins = $('#phase_release_plots_send_to_admins').is(":checked");

    return json;
  },

  // get the phase
  getPhase: function(){
    return $('#phase_release_plots_phase_id')[0].value
  },

  // Validate the form data and send it to the controller for analysis
  validate: function() {

    // Remove any alerts and notices
    $( ".alert" ).remove();
    $( ".notice" ).remove();

    // Get the data and tag the required action as 'validate'
    fd = release.formData()
    fd.req = "validate"

    // Check that the minimum data set is populated
    if (fd.list == "" || fd.release_date == "") {
      $('.flash').empty().append('<p class=alert>' + "Please populate plots and date" + '</p>')
    } else if (Date.parse($('#phase_release_plots_release_date')[0].value) > new Date()) {
      $('.flash').empty().append('<p class=alert>' + "Release date cannot be in the future" + '</p>')
    } else {
      // Call the controller to do the analysis
      $.getJSON({
      url: '/phases/' + release.getPhase() + '/callback',
      data: fd
      }).done(function (results) {
        // If the validation succeeds
        if (results.valid == true)  {
          // Show the confirmation dialog
          release.Confirm(results)
        } else {
          // populate the flash band with the error details
          $('.flash').empty().append('<p class=alert>' + results.message + '</p>')
        }

      })
    }
  },

  // Confirm the release date updates by displaying the appropriate dialog content
  Confirm: function(results) {

    f = release.formData()

    // Note: _ in data content names are translated to camelCase automatically
    dialog_body = '<h3>Confirm</h3>' +
        '<div>' +
          '<p>Are you sure you want to send the ' + f.release_type.match(/^[a-z]+/) + ' email and update release date to ' + results.release_date + '?</p>' +
        '</div>' +
        '<div>' +
          '<p>Order number: ' + f.order_number + '</p>' +
          '<p>Number of plots: ' + results.num_plots  + '</p>' +
          '<p>Plots: ' + results.plot_numbers  + '</p>'

    if (f.validity) { dialog_body = dialog_body + '<p>Validity: ' + f.validity  + '</p>' }
    if (f.extended) { dialog_body = dialog_body + '<p>Extended: ' + f.extended  + '</p>' }

    dialog_body = dialog_body +'</div>'

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
            release.bulk_update(results.plot_numbers)
            $(this).dialog('close')
            $(this).dialog('destroy').remove()
          }
        }]
    }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
  },

  // POST back the confirmed data to the controller
   bulk_update: function(plot_numbers){

    fd = release.formData();
    fd.plot_numbers = plot_numbers

    $.post('/phases/' + release.getPhase() + '/release_plots', fd)
  }

}
