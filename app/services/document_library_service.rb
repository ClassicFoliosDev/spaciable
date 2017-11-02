# frozen_string_literal: true

module DocumentLibraryService
  module_function

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable MethodLength
  def call(documents, appliances)
    alldocuments = documents.map do |d|
      { name: d.title, link: d.file.url, category: d.category, id: d.id,
        thumb: build_preview(d.file), timestamp: d.updated_at }
    end
    manuals = appliances.map do |a|
      if a.manual?
        { name: a.to_s, link: a.manual.url, parent: a, category: I18n.t(".manual"),
          thumb: build_preview(a.manual), timestamp: a.updated_at }
      end
    end
    guides = appliances.map do |a|
      if a.guide?
        { name: a.to_s, link: a.guide.url, parent: a, category: I18n.t(".guide"),
          thumb: build_preview(a.guide), timestamp: a.updated_at }
      end
    end

    alldocuments.concat(manuals.compact)
                .concat(guides.compact)
                .sort_by { |hash| hash[:timestamp] }.reverse.take(6)
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable MethodLength

  # Retrieve a preview thumbnail for a PDF with the correct content type set.
  #
  # Without overriding the content_type, the headers would return 'application/pdf'
  # for the preview image, and all browsers except for Safari will show the image
  # (regardless of the content type header). This fixes the preview thumbs for Safari.
  def build_preview(file)
    file.preview&.url(query: { "response-content-type" => "image/jpeg" })
  end
end
