# frozen_string_literal: true

module DocumentPreviewHelper
  def document_preview_url(file)
    if file.type_pdf?
      "pdf_icon.jpg"
    else
      return file.preview.url(response_content_type: %( "image/jpeg" )) if file.preview.present?

      file.url(response_content_type: %( "image/svg+xml"))
    end
  end
end
