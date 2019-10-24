# frozen_string_literal: true

module DocumentLibraryService
  module_function

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable MethodLength
  def call(documents, appliances)
    alldocuments = documents.map do |d|
      { name: d.title, link: d.file.url, category: d.category, id: d.id,
        thumb: library_preview_url(d.file), timestamp: d.updated_at, pinned: d.pinned }
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

    # documents are sorted first by pinned and last updated, and then appliance
    # manuals and guides are added, meaning that recent documents on homeowner and admin dashboard
    # will not show appliance manuals or guides if there are 5 or more documents
    alldocuments = alldocuments.sort_by { |hash| [hash[:pinned] ? 1 : 0, hash[:timestamp]] }
                               .reverse
    manuals_guides = manuals.compact.concat(guides.compact)
                            .sort_by { |hash| hash[:timestamp] }.reverse
    documents = alldocuments.concat(manuals_guides).take(6)

    documents.each do |document|
      Rails.logger.debug(document[:thumb])
    end

    documents
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable MethodLength

  def library_preview_url(file)
    return file.preview.url(response_content_type: %( "image/jpeg" )) if file.preview.present?

    file.url(response_content_type: %( "image/svg+xml"))
  end
end
