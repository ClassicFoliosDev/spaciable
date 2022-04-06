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
    return active_tiles unless plot.free? || plot.essentials?
    return active_tiles.reject { |ct| ct.snagging? || ct.perks? || ct.home_designer? || !ct.cf } if plot.free?
    active_tiles.reject(&:snagging?)
  end
  # rubocop:enable LineLength

  # Spotlights have 2 possible custom tiles, only one of which may
  # possibly currently be active
  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, AbcSize, LineLength
  def tile(plot)
    custom_tile = pre_move
    # static spotlight options
    return custom_tile if always?
    return custom_tile if moved_in? && plot.completion_date && Time.zone.today >= plot.completion_date
    return custom_tile if completed? && plot.completion_release_date && Time.zone.today >= plot.completion_release_date
    return nil if static? # doesn't match the selected static option

    # dynamic spotlights

    # No dynamic spotlight shows unless it has an EMD
    return nil unless plot.completion_date?

    # Pre-Move/Static.  Shows if the EMD qualifies for display and the date is pre-EMD, OR the
    # EMD doesn't qualify but the all_or_nothing switch is false
    emd_qualifies = qualifies(plot)
    return custom_tile if ((Time.zone.today < plot.completion_date) && emd_qualifies) ||
                          !(emd_qualifies || all_or_nothing?)

    # If the EMD doesn't qualify and its all_or_nothing, then show nothing!
    return nil if !emd_qualifies && all_or_nothing?

    # Post-Move, post EMD
    custom_tile = post_move

    # return nil if the custom tile has expired
    return nil if expired?(plot)
    # qualifies
    custom_tile
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, AbcSize, LineLength

  def qualifies(plot)
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
    when :to_year.to_s
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
