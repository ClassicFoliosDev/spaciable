/* global $, clearFields, setFields */

(function (document, $) {
  'use strict'

  $(document).on('click', '#upload-btn', function (event) {
    // disable upload button
    upload_doc(extract_document())
  })

})(document, window.jQuery)

function extract_document(){
  // get the first checked (synced) row.
  row = $(".documents tbody tr td input:checked").first().closest('tr')
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
   // enable upload buton
   return
  }
  scope = "tr input[id$='documents_document_key'][value$='" + doc.document_key + "']"
  loader = $('tbody').find(scope).parent().find('#loader').addClass("loader")

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
      flash_alert('Unable to download document ' + extract_document().documents_display_name)
  })
}

