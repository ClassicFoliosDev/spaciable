# frozen_string_literal: true

# rubocop:disable ClassLength
class Spotlight < ApplicationRecord
  include AppearsEnum

  belongs_to :development
  has_many :custom_tiles, -> { order(:order) }, dependent: :destroy
  accepts_nested_attributes_for :custom_tiles, allow_destroy: true
  alias parent development

  before_create :set_cf
  before_save :set_cf
  after_save :check_dates

  delegate :snag_name, to: :development

  validates :start, presence: true, if: proc { emd_on_after? || emd_on_before? || emd_between? }
  validates :finish, presence: true, if: proc { emd_between? }
  validate :start_before_finish

  enum category: %i[
    static
    dynamic
  ]

  enum expiry: %i[
    never
    one_year
    two_years
  ]

  enum move: {
    pre: 0,
    post: 1
  }

  def start_before_finish
    return unless start && finish && start > finish
    errors.add(:start, "must be before Finish")
  end

  def parent
    development
  end

  # rubocop:disable LineLength, MultilineTernaryOperator
  def title
    return I18n.t("spotlight.dynamic") if dynamic?
    custom_tile = custom_tiles.first
    custom_tile.title? ? custom_tile.title :
                         I18n.t("activerecord.attributes.custom_tiles.features.#{custom_tile.feature}", snag_name: snag_name)
  end
  # rubocop:enable LineLength, MultilineTernaryOperator

  # rubocop:disable LineLength
  def build(development)
    (0..1).each { |i| custom_tiles.build(custom_snagging_name: development&.snag_name, order: i) unless custom_tiles[i] }
  end
  # rubocop:enable LineLength

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
    return active_tiles.reject { |ct| ct.snagging? || ct.perks? || ct.home_designer? || !ct.cf } if plot.free?
    active_tiles
  end
  # rubocop:enable LineLength

  # Spotlights have 2 possible custom tiles, only one of which may
  # possibly currently be active
  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, AbcSize, LineLength, NegatedIf
  def tile(plot)
    custom_tile = pre_move
    # static spotlight options
    return custom_tile if always?
    return custom_tile if moved_in? && plot.completion_date && Time.zone.today >= plot.completion_date
    return custom_tile if completed? && plot.completion_release_date && Time.zone.today >= plot.completion_release_date
    return nil if static? # doesn't match the selected static option

    # dynamic spotlights - does EMD qualify?
    emd_qualifies = qualifies(plot)

    # return Pre-Move if EMD doesn't qualify but its not 'all_or_nothing'
    return custom_tile if !(emd_qualifies || all_or_nothing)
    # return nil unless the EMD qualifies
    return nil unless emd_qualifies
    # So emd qualifies, is it before EMD?
    return custom_tile if Time.zone.today < plot.completion_date

    # Post-Move, post EMD
    custom_tile = post_move

    # return nil if the custom tile has expired
    return nil if expired?(plot)
    # qualifies
    custom_tile
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, AbcSize, LineLength, NegatedIf

  def qualifies(plot)
    return false unless plot.completion_date?
    return true if after_emd?
    return plot.completion_date >= start if emd_on_after?
    return plot.completion_date <= start if emd_on_before?
    plot.completion_date >= start && plot.completion_date <= finish
  end

  def pre_move
    custom_tiles.first
  end

  def post_move
    custom_tiles.second
  end

  def expired?(plot)
    return true unless plot.completion_date?

    case expiry
    when :one_year.to_s
      Time.zone.today > (plot.completion_date + 1.year)
    when :two_years.to_s
      Time.zone.today > (plot.completion_date + 2.years)
    else
      false
    end
  end

  # rubocop:disable Rails/SkipsModelValidations
  def check_dates
    update_column(:start, nil) unless emd_on_after? || emd_on_before? || emd_between?
    update_column(:finish, nil) unless emd_between?
  end
  # rubocop:enable Rails/SkipsModelValidations

  private

  # was this spotlight created/updated by a CF user
  def set_cf
    return unless RequestStore.store[:current_user]&.is_a? User
    return unless changed?
    self.cf = RequestStore.store[:current_user]&.cf_admin? || false
  end
end
# rubocop:enable ClassLength
