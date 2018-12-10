# frozen_string_literal: true

module DocumentLibraryService
  module_function

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable MethodLength

  def call(documents, appliances)
    alldocuments = documents.map do |d|
      { name: d.title, link: d.file.url, category: d.category, id: d.id,
        thumb: library_preview_url(d.file), timestamp: d.updated_at }
    end
    manuals = appliances.map do |a|
      if a.manual?
        { name: a.to_s, link: a.manual.url, parent: a, category: I18n.t(".manual"),
          thumb: library_preview_url(a.manual), timestamp: a.updated_at }
      end
    end
    guides = appliances.map do |a|
      if a.guide?
        { name: a.to_s, link: a.guide.url, parent: a, category: I18n.t(".guide"),
          thumb: library_preview_url(a.guide), timestamp: a.updated_at }
      end
    end

    documents = alldocuments.concat(manuals.compact)
                            .concat(guides.compact)
                            .sort_by { |hash| hash[:timestamp] }.reverse.take(6)

    documents.each do |document|
      Rails.logger.debug(document[:thumb])
    end

    documents
  end

  # rubocop:enable Metrics/AbcSize
  # rubocop:enable MethodLength

  def library_preview_url(file)
    if file.type_pdf?
      "pdf_icon.jpg"
    else
      return file.preview.url(response_content_type: %( "image/jpeg" )) if file.preview.present?

      file.url(response_content_type: %( "image/svg+xml"))
    end
  end
end
