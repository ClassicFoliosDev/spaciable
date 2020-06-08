# frozen_string_literal: true

class CustomTile < ApplicationRecord
  include HTTParty

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

  def documents_in_scope
    documents = []
    documents << development.documents
    documents << development.parent.documents

    if development.parent.is_a?(Division)
      documents << development.parent_developer.documents
    end

    # return the list of documents in alphabetical order
    documents.flatten!.sort_by { |doc| doc.title.downcase }
  end

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

  ## code revire

  def self.active_tiles(plot, documents)
    custom_tiles = CustomTile.where(development_id: plot.development)
    active_tiles = []

    custom_tiles.each do |tile|
      active_tiles << tile if tile.feature? && tile.active_feature(plot)
      active_tiles << tile if tile.document? && tile.active_document(documents)
      active_tiles << tile if tile.link?
    end

    active_tiles
  end

  def active_feature(plot)
    return true unless snagging? || issues?
    return true if snagging? && plot.snagging_valid
    return true if issues? && plot.show_maintenance?
    false
  end

  def active_document(documents)
    return true if file? || document_id?
    if guide?
      return true if completion? && completion_guide(documents)
      return true if reservation? && reservation_guide(documents)
    end
    false
  end

  def completion_guide(documents)
    documents.find_by(guide: "completion")
  end

  def reservation_guide(documents)
    documents.find_by(guide: "reservation")
  end

  def iframeable?(link)
    return false if HTTParty.get(link, verify: false).headers.key?("x-frame-options")
    true
  rescue
    false
  end

  def self.delete_disabled(features, developments)
    tiles = CustomTile.where(development_id: developments, feature: features)
    tiles.destroy_all
  end
end
