
var bulk_delete_category = '#BulkDeleteCategorySelector'
var bulk_delete_guide = '#BulkDeleteGuideSelector'
var deleteTimer
var plot_selected = new Boolean(false)

document.addEventListener('turbolinks:load', function () {
  if ($(bulk_delete_category).length == 0) { return }

  bulk_delete.show_hide_guide()
  bulk_delete.populate()

  // Add on onClick handler for the submit button
  document.getElementById("submit-bulk-delete-btn").addEventListener("click", bulk_delete.submit);
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

$(document).on('mouseup', '.delete_doc', function (event, element) {
  clearTimeout(deleteTimer)
  if (plot_selected == true) { this.checked = !this.checked }
})

$(document).on('mousedown', '.delete_doc', function (event, element) {
  plot_selected = false
  deleteTimer = window.setTimeout(function(){
    plot_selected = true
    checked = !this.checked
    $("tr[data-plot='" + $(event.target).data("plot") + "'] input").each(function( index, element ) {
       $(element).prop("checked", checked)
    });
  }, 1000)
})

var bulk_delete = {
  $documents: "",
  $currentPlot: "",
  $checked_documents: "",

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
    $currentPlot = ""
    $("#delete_all_docs").prop("checked", false)
    $("#plot_documents").empty()
    $response.forEach(bulk_delete.render_row);
  },

  render_row: function(row) {
    var plot = ""

    if ($currentPlot != row["number"]) { $currentPlot = plot = row["number"] }

    $('.record-list > tbody:last-child').append(
            '<tr data-document = "' + row["id"] + '" data-plot = "' + $currentPlot + '">'
            + '<td><a title="' + plot + '" href="/plots/' + row["plot_id"] + '">' + plot + '</a></td>'
            +'<td colspan="2">'+ row["title"] + '</td>'
            +'<td>'+ row["category"] + '</td>'
            +'<td>'+ row["guide"] + '</td>'
            +'<td><input type="checkbox" class="delete_doc" data-plot = "' + $currentPlot + '"></td>'
            +'</tr>');
  },

  submit: function() {
    $checked_documents = $( '.record-list' )
                        .find( 'tbody' ).find( 'tr' )
                        .has( 'input[type=checkbox]:checked')

    if ($checked_documents.length == 0) { return }
    bulk_delete.confirm()
  },

  confirm: function() {
    dialog_body = '<div>' +
                    '<p style="margin:0">Are you sure you want to delete the <strong>' +
                    $checked_documents.length +
                    '</strong> selected plot document/s?</p>' 
                    '</div>'

    var $dialogContainer = $('<div>', { id: 'dialog', class: 'archive-dialog' })
      .html(dialog_body)

    // Display the modal dialog and ask for confirm/cancel
    $(document.body).append($dialogContainer)

    $dialogContainer.dialog({
      title: "Delete Plot Documents",
      show: 'show',
      modal: true,
      dialogClass: 'archive-dialog',
      buttons: [
        {
          text: "Cancel",
          class: 'btn-secondary',
          click: function () {
            $(this).dialog('close')
            $(this).dialog('destroy').remove()
          }
        },
        {
          text: "Confirm",
          class: 'btn-primary',
          id: 'btn_confirm',
          click: function () {
            bulk_delete.delete()
            $(this).dialog('close')
            $(this).dialog('destroy').remove()
          }
        }]
    }).prev().find('.ui-dialog-titlebar-close').hide()
  },

  delete: function() {

    $.ajax({
      url: 'bulk_delete/delete',
      type: "POST",
      data: { docs: arr = $.makeArray($checked_documents).map((item) => $(item).data("document")) },
      success: function(data) {
                 bulk_delete.populate();
               }
    })
  }
}

