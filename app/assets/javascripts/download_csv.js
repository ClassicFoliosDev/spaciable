$(document).on('turbolinks:load', function () {

  if($('.upload-csv').length == 0 ) { return }

  $('.file-upload').on('click touchstart' , function(){
    $(this).val('')
    $('.upload-csv').hide()
  })


  //Trigger now when you have selected any file
  $(".file-upload").change(function(e) {
    $('.upload-csv').toggle($(this).val() != '')
  })
})
