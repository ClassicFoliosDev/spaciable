# frozen_string_literal: true

module DocumentPreviewHelper
  def document_preview_url(file)
    if file.type_image?
      return file.preview.url(response_content_type: %( "image/jpeg" )) if file.preview.present?

      file.url(response_content_type: %( "image/svg+xml"))
    else
      "pdf_icon.jpg"
    end
  end
end
