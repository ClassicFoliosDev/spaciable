# frozen_string_literal: true

class Spotlight < ApplicationRecord
  belongs_to :development
  has_many :custom_tiles, -> { order(:order) }, dependent: :destroy
  accepts_nested_attributes_for :custom_tiles, allow_destroy: true
  alias parent development

  before_create :set_cf
  before_save :set_cf

  enum category: %i[
    static
    dynamic
  ]

  def parent
    development
  end

  # rubocop:disable LineLength, MultilineTernaryOperator
  def title
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

  private

  # was this spotlight created/updated by a CF user
  def set_cf
    return unless RequestStore.store[:current_user]&.is_a? User
    return unless changed?
    self.cf = RequestStore.store[:current_user]&.cf_admin? || false
  end
end
