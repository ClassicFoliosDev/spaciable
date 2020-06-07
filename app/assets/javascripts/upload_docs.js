/* global $, clearFields, setFields */

(function (document, $) {
  'use strict'

  $(document).on('click', '#upload-btn', function (event) {
    $('.form-actions-footer').hide()
    flash_clear()
    upload_doc(extract_document())
  })

})(document, window.jQuery)

function extract_document(){
  // get the first checked (synced) row.
  row = first_checked().closest('tr')
  if (row.length == 0) { return }

  // extract data
  doc = {};
  doc.document_key = row.find('#documents_document_key').val()
  doc.record_key = row.find('#documents_record_key').val()
  doc.file_name = row.find('#documents_file_name').val()
  doc.display_name = row.find('#documents_display_name').val()
  doc.updated_at = row.find('#documents_updated_at').val()
  if (doc.display_name == "") { doc.display_name = doc.file_name }
  doc.category = row.find('#documents_category').val()
  doc.meta = row.find('#documents_meta').val()
  return doc
}

// Upload the document - then recurse until finished
function upload_doc(doc) {
  if (typeof doc == "undefined") {
    $('.form-actions-footer').show()
    return
  }

  add_remove_loader(doc.document_key, true)

  $.post({
    url: $('#documents').attr('action'),
    data: doc,
    dataType: 'json',
    success: function (response) {
      // remove the entry
      scope = "tr input[id$='documents_document_key'][value$='" + response["key"] + "']"
      $('tbody').find(scope).parent().remove()

      // recurse and upload the next document
      upload_doc(extract_document())
    }
  }).fail(function() {
      doc = extract_document()
      first_checked().prop('checked', false);
      add_remove_loader(doc.document_key, false)
      flash_alert('Unable to download document ' + doc.display_name)
      upload_doc(extract_document())
  })
}

function first_checked(){
  return $(".documents tbody tr td input:checked").first()
}

// Add/remove loader gif
function add_remove_loader(key, add){
  scope = "tr input[id='documents_document_key'][value='" + key + "']"
  loader = $('tbody').find(scope).parent().find('#loader')
  if (add){
    loader.addClass("loader")
  }
  else {
    loader.removeClass("loader")
  }
}


