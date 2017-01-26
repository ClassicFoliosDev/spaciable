$(document).on('click', '.remove-image', function (event) {

  var $fieldSet = $(this).closest("fieldset");

  $fieldSet.find(".image-preview").hide();
  $fieldSet.find(".image-name").hide();
  $fieldSet.find(".picture-label").hide();
  $fieldSet.find(".remove-btn").hide();
});
