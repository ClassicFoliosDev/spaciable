
var bulk_delete_category = '#BulkDeleteCategorySelector'
var bulk_delete_guide = '#BulkDeleteGuideSelector'

document.addEventListener('turbolinks:load', function () {
  if ($(bulk_delete_category).length == 0) { return }
  bulk_delete.show_hide_guide()
  bulk_delete.populate()
})

// show or hide the guide selector on category change
$(document).on('click', '#phase_bulk_delete_category-menu', function (event) {
  bulk_delete.show_hide_guide()
  bulk_delete.populate()
})



// show or hide the guide selector on guide change
$(document).on('click', '#phase_bulk_delete_guide-menu', function (event) {
  bulk_delete.populate()
})

$(document).on('change', '#delete_all_docs', function (event) {
  checked = this.checked
    $(".delete_doc").each(function( index, element ) {
       $(element).prop("checked", checked)
    });
})

var bulk_delete = {
  $documents: "",

  show_hide_guide: function() {
    if ($(bulk_delete_guide).length) {
      if ($(bulk_delete_category).find('option[value=my_home]')[0].selected) {
        $("#BulkDeleteGuideSelector select")[0].selectedIndex = 0
        $('#BulkDeleteGuideSelector .ui-selectmenu-text')[0].innerHTML = $('#BulkDeleteGuideSelector select option:selected').text()
        $(bulk_delete_guide).show()
      } else {
        $(bulk_delete_guide).hide()
      }
    }
  },

  populate: function() {
    $.ajax({
      url: 'bulk_delete/documents',
      type: "GET",
      data: { category: $("#phase_bulk_delete_category").val(),
              guide: $("#phase_bulk_delete_guide").val() },
      success: function(data) {
                 $response = data
                 bulk_delete.render();
               }
    })
  },

  render: function() {
    $("#plot_documents").empty()
    $response.forEach(bulk_delete.render_row);
  },

  render_row: function(row) {
    $('.record-list > tbody:last-child').append(
            '<tr data-document = "' + row["id"] + '">'
            +'<td>'+ row["number"] + '</td>'
            +'<td colspan="2">'+ row["title"] + '</td>'
            +'<td>'+ row["category"] + '</td>'
            +'<td>'+ row["guide"] + '</td>'
            +'<td><input type="checkbox" class="delete_doc"></td>'
            +'</tr>');
  },

  delete: function() {

  }
}

