# frozen_string_literal: true

class CustomTile < ApplicationRecord
  belongs_to :development

  mount_uploader :file, DocumentUploader
  mount_uploader :image, PictureUploader
  attr_accessor :image_cache

  validates :title, :description, :button, presence: true, unless: :feature
  validates :link, presence: true, if: :link?
  # validates one of file, guide or document_id is present if: :guide

  def parent
    development
  end

  enum category: %i[
    feature
    document
    link
  ]

  enum feature: %i[
    area_guide
    home_designer
    referrals
    services
    perks
    issues
    snagging
  ]

  enum guide: %i[
    reservation
    completion
  ]

  def snag_name
    development.snag_name
  end

  def not_feature

  end

  def documents_in_scope
    documents = []
    documents << Document.where(documentable_id: development_id,
                                documentable_type: 'Development')

    documents << Document.where(documentable_type: development.parent.id,
                               documentable_type: development.parent.model_name.human)

    if development.parent.is_a?(Division)
      documents << Document.where(documentable_id: development.parent_developer.id,
                                  documentable_type: 'Developer')
    end

    # return the list of documents in alphabetical order
    documents.flatten!.sort_by { |doc| doc.title.downcase }
  end
end
