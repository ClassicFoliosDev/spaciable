/* global $, clearFields, setFields */

$(document).ready(function() {

  // Add on onClick handler for the submit button
  document.getElementById("submit-bulk-btn").addEventListener("click", CheckUnitType);

  // Is the unit type being updated?
  function CheckUnitType() {

    if ($('#phase_bulk_edit_build_step_id_check').prop("checked") &&
        $("#phase_bulk_edit_build_step_id :selected").text() === "") {
      cancel_dialog("Select Build Progress", "Please make a Build Progress selection")
    } else {
      $('#phase_bulk_edit_unit_type_id_check').prop("checked") ? Confirm() : Submit()
    }
  }

  // Confirm which unit type update option you want
  function Confirm () {

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
            $('#phase_bulk_edit_ut_update_option').val($('input[name=ut_option]:checked').val())
            Submit()
            $(this).dialog('close')
            $(this).dialog('destroy').remove()
          }
        }]
    }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
  }

  function Submit(){
    var x = document.getElementsByClassName("phase_bulk_edit");
    x[0].submit(); // Form submission
  }

})
