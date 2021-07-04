# frozen_string_literal: true

# Timeline Task features
class Feature < ApplicationRecord
  include FeatureTypeEnum

  belongs_to :task, touch: true

  validates :title, presence: true

  validate :featuretype

  def featuretype
    return unless feature_type == :custom_url.to_s

    errors.add(:link, "please specify a valid url") if link.blank?
  end

  def self.featuretypes(timeline, override = false)
    feature_types.select { |name, _| override || timeline&.supports?(name) }.map do |name, _|
      [name, I18n.t("activerecord.attributes.feature.#{name}")]
    end
  end
end
