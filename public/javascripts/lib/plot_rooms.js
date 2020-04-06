/* global $, clearFields, setFields */

$(document).ready(function() {

  // Add on onClick handler for the submit button
  document.getElementById("submit-plot-btn").addEventListener("click", CheckUnitType);
  // note the currently selected unit type
  $old_unit_type = $('#plot_unit_type_id').children("option:selected").text()

  // Has the unit type changed?
  function CheckUnitType() {
    $new_unit_type = $('.plot_unit_type > span.ui-selectmenu-button > span.ui-selectmenu-text').text()
    $old_unit_type != $new_unit_type ? Confirm() : Submit()
  }

  // Confirm which unit type update option you want
  function Confirm () {

    // insert the old/new unit type and plot number in the message text
    header = $('#ut_header').html()
             .replace("%{old_ut}", $old_unit_type)
             .replace("%{new_ut}", $new_unit_type)
             .replace("%{plot}", $('#plot_number').val())
    $('#ut_header').html(header)

    var $option_container = $('.ut-update-option-form')
    $('body').append($option_container)

    $option_container.dialog({
      show: 'show',
      modal: true,
      width: 700,
      title: "Change Unit Type",
      buttons: [
        {
          text: "Cancel",
          class: 'btn',
          click: function () {
            $(this).dialog('destroy')
          }
        },
        {
          text: "Confirm",
          class: 'btn-primary',
          id: 'btn_confirm',
          click: function () {
            $('#plot_ut_update_option').val($('input[name=ut_option]:checked').val())
            Submit()
            $(this).dialog('close')
            $(this).dialog('destroy').remove()
          }
        }]
    }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
  }

  function Submit(){
    var x = document.getElementsByClassName("edit_plot");
    x[0].submit(); // Form submission
  }

})
