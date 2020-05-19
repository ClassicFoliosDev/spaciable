# frozen_string_literal: true

class CustomTile < ApplicationRecord
  belongs_to :development

  mount_uploader :file, DocumentUploader
  mount_uploader :image, PictureUploader
  attr_accessor :image_cache

  validates :title, :description, :button, presence: true, unless: :feature?
  validates :link, presence: true, if: :link?
  validate :document_sub_category, if: :document?
  validates :feature, presence: true, if: :feature?

  def parent
    development
  end

  enum category: %i[
    feature
    document
    link
  ]

  enum feature: {
    area_guide: 0,
    home_designer: 1,
    referrals: 2,
    services: 3,
    perks: 4,
    issues: 5,
    snagging: 6
  }

  enum guide: %i[
    reservation
    completion
  ]

  delegate :snag_name, to: :development

  def document
    Document.find_by(id: document_id)
  end

  def document_sub_category
    return if guide.present? || file.present? || document_id.present?
    errors.add(:base, :document_sub_category_required)
  end

  # rubocop:disable Metrics/AbcSize
  def documents_in_scope
    documents = []
    documents << Document.where(documentable_id: development_id,
                                documentable_type: "Development")

    documents << Document.where(documentable_id: development.parent.id,
                                documentable_type: development.parent.model_name.human)

    if development.parent.is_a?(Division)
      documents << Document.where(documentable_id: development.parent_developer.id,
                                  documentable_type: "Developer")
    end

    # return the list of documents in alphabetical order
    documents.flatten!.sort_by { |doc| doc.title.downcase }
  end
  # rubocop:enable Metrics/AbcSize

  def document_location(documents)
    if document_id
      document.file.url
    elsif guide
      doc = documents.find_by(guide: guide)
      doc.file.url
    elsif file
      file.url
    end
  end
end
