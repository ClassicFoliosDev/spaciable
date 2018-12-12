# frozen_string_literal: true

module DocumentPreviewHelper
  def document_preview_url(file)
    if file.type_pdf?
      "pdf_icon.jpg"
    elsif file.blank?
      "logo.png"
    else
      file.preview&.url(response_content_type: %( "image/jpeg" ))
    end
  end
end
