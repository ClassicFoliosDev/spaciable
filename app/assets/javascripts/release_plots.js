/* global $, clearFields, setFields */

document.addEventListener('turbolinks:load', function () {

  // Add on onClick jandler for the submit button
  document.getElementById("submit").addEventListener("click", validate);

  // Extract the data fields from the form
  function formData (){

    json = {};
    json.mixed_list = $('#phase_release_plots_mixed_list')[0].value
    json.release_type = $('#release_type')[0].value
    json.release_date = $('#phase_release_plots_release_date')[0].value
    json.validity = $('#phase_release_plots_validity')[0].value
    json.extended = $('#phase_release_plots_extended_access')[0].value
    json.send_to_admins = $('#phase_release_plots_send_to_admins').is(":checked");

    return json;
  }

  // get the phase
  function getPhase(){
    return $('#phase_release_plots_phase_id')[0].value
  }

  // Validate the form data and send it to the controller for analysis
  function validate() {

    // Remove any alerts and notices
    $( ".alert" ).remove();
    $( ".notice" ).remove();

    // Get the data and tag the required action as 'validate'
    fd = formData()
    fd.req = "validate"

    // Check that the minimim data set is populated
    if (fd.mixed_list == "" || (fd.release_date == "" && fd.validity == "" && fd.extended == "")) {
      $('.flash').append('<p class=alert>' + "Please populate fields" + '</p>')
    } else {
      // Call the controller to do the analysis
      $.getJSON({
      url: '/phases/' + getPhase() + '/callback',
      data: fd
      }).done(function (results) {
        // If the validation succeeds
        if (results.valid == true)  {
          // Show the confirmation dialog
          Confirm(results)
        } else {
          // populate the flash band with the error details
          $('.flash').append('<p class=alert>' + results.message + '</p>')
        }

      })
    }
  }

  // Confirm the release date updates by displaying the appropriate dialog content
  function Confirm (results) {

    f = formData ()

    // Note: _ in data content names are translated to camelCase automatically
    dialog_body = '<h3>Confirm</h3>' +
        '<div>'

    if (f.release_date) {
    dialog_body = dialog_body + 
          '<p>Are you sure you want to send the ' + f.release_type.match(/^[a-z]+/) + ' email and update release date to ' + results.release_date + '?</p>'
    } else if (f.validity && f.extended && f.extended != 0) {
      dialog_body = dialog_body + 
          '<p>Are you sure you want to update the Extended access to ' + f.extended + ' month(s) and the Valdity to ' + f.validity + ' month(s)?</p>'
    } else if (f.validity && f.validity) {
      dialog_body = dialog_body + 
          '<p>Are you sure you want to update the Validity to ' + f.validity + ' month(s)?</p>'
    } else {
      dialog_body = dialog_body + 
          '<p>Are you sure you want to update the Extended access to ' + f.extended + ' month(s)?</p>'
    }

    dialog_body = dialog_body + 
        '</div>' + 
        '<div>' + 
          '<p>Number of plots: ' + results.num_plots  + '</p>' + 
          '<p>Plots: ' + results.plot_numbers  + '</p>'

    if (f.release_date && f.validity) { dialog_body = dialog_body + '<p>Validity: ' + f.validity  + '</p>' }
    if (f.release_date && f.extended && f.extended != 0) { dialog_body = dialog_body + '<p>Extended: ' + f.extended  + '</p>' }

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
            bulk_update(results.plot_numbers)
            $(this).dialog('close')
            $(this).dialog('destroy').remove()
          }
        }]
    }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
  }

  // POST back the confirmed data to the controller
  function bulk_update(plot_numbers){

    fd = formData();
    fd.plot_numbers = plot_numbers

    $.post('/phases/' + getPhase() + '/release_plots', fd)
  }


  // Add another click listener for the 'All Plots' button
  document.getElementById("add_plots").addEventListener("click", addAllPlots);

  // Just ask the controller for all plots for the phase, then
  // put them in the mixed_list area
  function addAllPlots() {

    // Remove any alerts and notices
    $( ".alert" ).remove();
    $( ".notice" ).remove();
    
    $.getJSON({
    url: '/phases/' + getPhase() + '/callback',
    data: { req: "all_plots" }
    }).done(function (plots) {
      $('#phase_release_plots_mixed_list').val(plots.plots); 
    })

  }

})
