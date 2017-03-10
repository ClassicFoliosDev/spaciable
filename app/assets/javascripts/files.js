$(document).on('click', '.remove-image', function (event) {

  var $imagePreview = $(this).closest(".image_preview");

  $imagePreview.find(".image-preview").hide();
  $imagePreview.find(".image-name").hide();
  $imagePreview.find(".picture-label").hide();
  $imagePreview.find(".remove-btn").hide();
});

$(document).on('click', '.remove-document', function (event) {

  var $docPreview = $(this).closest(".appliance-manual");

  $docPreview.hide();
});


