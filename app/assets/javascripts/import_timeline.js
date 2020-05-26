
$(document).on('click', '.import-timeline', function (event) {

  // get the developer and the selected timeline
  var developer = $('#developer_developer_id').val()
  var timeline = $('#developer_timeline_id').children('option:selected').val()

  window.location.replace("/developers/"+developer+"/timelines/"+ timeline+"/clone")
})
