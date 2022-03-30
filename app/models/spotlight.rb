# frozen_string_literal: true

class Spotlight < ApplicationRecord
  belongs_to :development
  has_many :custom_tiles, -> { order(:order) }, dependent: :destroy
  accepts_nested_attributes_for :custom_tiles, allow_destroy: true
  alias parent development

  before_create :set_cf
  before_save :set_cf

  delegate :snag_name, to: :development

  enum category: %i[
    static
    dynamic
  ]

  def parent
    development
  end

  # rubocop:disable LineLength, MultilineTernaryOperator
  def title
    return I18n.t("spotlight.dynamic") if dynamic?
    custom_tile = custom_tiles.first
    custom_tile.title? ? custom_tile.title :
                         I18n.t("activerecord.attributes.custom_tiles.features.#{custom_tile.feature}")
  end
  # rubocop:enable LineLength, MultilineTernaryOperator

  def build
    (0..1).each { |i| custom_tiles.build(order: i) unless custom_tiles[i] }
  end

  def self.delete_disabled(features, developments)
    spotlights = Spotlight.joins(:custom_tiles)
                          .where(development_id: developments)
                          .where(custom_tiles: { feature: features })

    spotlights.destroy_all
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

  # rubocop:disable Metrics/CyclomaticComplexity
  def self.active_tiles(plot, documents)
    spotlights = Spotlight.where(development_id: plot.development)
    active_tiles = []

    spotlights.each do |spotlight|
      tile = spotlight.tile(plot)
      next if tile.blank?
      active_tiles << tile if tile.feature? && tile.active_feature(plot)
      active_tiles << tile if tile.document? && tile.active_document(documents)
      active_tiles << tile if tile.link?
      active_tiles << tile if tile.content_proforma? && tile.proforma_assoc?(plot)
    end

    visible_tiles(active_tiles, plot)
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  # what tiles are visible according to the current rules
  # rubocop:disable LineLength
  def self.visible_tiles(active_tiles, plot)
    active_tiles = plot.visible_tiles(active_tiles)
    return active_tiles unless plot.free? || plot.essentials?
    return active_tiles.reject { |ct| ct.snagging? || ct.perks? || ct.home_designer? || !ct.cf } if plot.free?
    active_tiles.reject(&:snagging?)
  end
  # rubocop:enable LineLength

  # Spotlights have 2 possible custom tiles, only one of which may
  # possibly currently be active
  def tile(plot)
    custom_tile = custom_tiles.first
    # static spotlight
    return custom_tile unless dynamic?
    # dynamic spotlight
    return nil unless plot.completion_date?
    # Pre-Move
    return custom_tile if Time.zone.today < plot.completion_date
    # Post-Move, post EMD
    custom_tile = custom_tiles.second
    return nil if custom_tile.emd_date? && (plot.completion_date < custom_tile.appears_after_date)
    return nil if custom_tile.expired?(plot)
    # qualifies
    custom_tile
  end

  private

  # was this spotlight created/updated by a CF user
  def set_cf
    return unless RequestStore.store[:current_user]&.is_a? User
    return unless changed?
    self.cf = RequestStore.store[:current_user]&.cf_admin? || false
  end
end
