# frozen_string_literal: true
module DocumentPreviewHelper
  # Retrieve a preview thumbnail for a PDF with the correct content type set.
  #
  # Without overriding the content_type, the headers would return 'application/pdf'
  # for the preview image, and all browsers except for Safari will show the image
  # (regardless of the content type header). This fixes the preview thumbs for Safari.
  def document_preview_url(file)
    file.preview&.url(query: { "response-content-type" => "image/jpeg" })
  end
end
