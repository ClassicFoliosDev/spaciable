# frozen_string_literal: true

#rubocop:disable all
class CustomTile < ApplicationRecord
  include HTTParty
  include GuideEnum

  before_create :set_cf
  belongs_to :development
  belongs_to :tileable, polymorphic: true

  mount_uploader :file, DocumentUploader
  mount_uploader :image, PictureUploader
  attr_accessor :image_cache

  #validate :meta
  validates :title, presence: true, unless: :feature?
  validates :description, presence: true, :unless => Proc.new { |ct| ct.feature? || !ct.render_description? }
  validates :button, presence: true, :unless => Proc.new { |ct| ct.feature? || !ct.render_button? }
  validate :proforma, if: :content_proforma?
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
    content_proforma
  ]

  enum feature: {
    area_guide: 0,
    home_designer: 1,
    referrals: 2,
    services: 3,
    perks: 4,
    issues: 5,
    snagging: 6,
    timeline: 7,
    conveyancing: 8
  }

  delegate :snag_name, to: :development

  def proforma
    return unless content_proforma?
    return if tileable.present?

    errors.add(:content_proforma, "is required, and must not be blank.")
    errors.add(:tileable_id, "please populate")
  end

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
      active_tiles << tile if tile.content_proforma? && tile.proforma_assoc?(plot)
    end

    visible_tiles(active_tiles, plot)
  end

  # what tiles are visible according to the current rules
  def self.visible_tiles(active_tiles, plot)
    return active_tiles unless plot.free? || plot.essentials?
    return active_tiles.reject { |ct| ct.snagging? || ct.perks? || ct.home_designer? || !ct.cf } if plot.free?
    active_tiles.reject { |ct| ct.snagging? }
  end

  def active_feature(plot)
    return true unless snagging? || issues? || timeline? || conveyancing?
    return true if snagging? && plot.snagging_valid
    return true if issues? && plot.show_maintenance?
    return true if timeline? && plot&.journey&.live?
    return true if conveyancing? && plot.conveyancing_enabled?
    false
  end

  def proforma_assoc?(plot)
    return false unless tileable.is_a? Timeline
    PlotTimeline.matching(plot, tileable)&.present?
  end

  def active_document(documents)
    return true if file? || document_id?
    CustomTile.guides.each { | g, _ | return true if guide_populated(g, documents) }
    false
  end

  def guide_populated(guide, documents)
    return send("#{guide}?") && documents.find_by(guide: guide)
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

  def formatted_link
    link !~ /\A(http)/ ? "https://#{link}" : link
  end

  # was this record created by a CF user
  def set_cf
    return unless RequestStore.store[:current_user]&.is_a? User
    self.cf = RequestStore.store[:current_user]&.cf_admin? || false
  end
end
#rubocop:enable all
