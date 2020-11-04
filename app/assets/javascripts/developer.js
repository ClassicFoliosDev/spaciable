$(document).on('keyup paste change', '#developer_company_name', function (event) {
  event.stopPropagation();
  parameterize(event)
})

function parameterize(event) {
  $.ajax({
    url: "/developers/custom/parameterize",
    type: "GET",
    data: { company_name: $("#developer_company_name").val() },
    success: function(response) {
      $("#developer_custom_url").val(response['custom_url'])
    }
  })
}
