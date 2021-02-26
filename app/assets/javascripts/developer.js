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

$(document).on('turbolinks:load', function () {

  conveyancing("#developer")
  conveyancing("#division")
})

function conveyancing(selector)
{
  if ($(selector + "_conveyancing").length != 0){
    $(selector + "_conveyancing").change(function() {
      check_wecomplete(selector)
    })
    check_wecomplete(selector)
  }
}

function check_wecomplete(selector)
{
  if($(selector + "_conveyancing").is(':checked')) {
    $("#wecomplete").show()
  } else {
    $("#wecomplete").hide()
    $(selector + "_wecomplete_sign_in").val("")
    $(selector + "_wecomplete_quote").val("")
  }
}

