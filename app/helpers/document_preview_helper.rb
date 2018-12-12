# frozen_string_literal: true

module DocumentPreviewHelper
  def document_preview_url(file)
    return file.preview.url(response_content_type: %( "image/jpeg" )) if file.preview.present?

    file.url(response_content_type: %( "image/svg+xml"))
  end
end
