document.addEventListener("turbolinks:load", function() {
  $('.ckeditor').each(function() {
    CKEDITOR.replace($(this).attr('id'))
  });
});
