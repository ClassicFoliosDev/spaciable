# frozen_string_literal: true
module DocumentLibraryService
  module_function

  def call(documents, appliances)
    alldocuments = documents.map do |d|
      { name: d.title, link: d.file.url,
        thumb: build_preview(d.file), timestamp: d.updated_at }
    end
    manuals = appliances.map do |a|
      { name: a.to_s, link: a.manual.url,
        thumb: build_preview(a.manual), timestamp: a.updated_at }
    end

    alldocuments.concat(manuals).sort_by { |hash| hash[:timestamp] }.reverse.take(6)
  end

  # Retrieve a preview thumbnail for a PDF with the correct content type set.
  #
  # Without overriding the content_type, the headers would return 'application/pdf'
  # for the preview image, and all browsers except for Safari will show the image
  # (regardless of the content type header). This fixes the preview thumbs for Safari.
  def build_preview(file)
    file.preview&.url(query: { "response-content-type" => "image/jpeg" })
  end
end
