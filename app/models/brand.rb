# frozen_string_literal: true
class Brand < ApplicationRecord
  include ActiveModel::Validations

  mount_uploader :logo, PictureUploader
  mount_uploader :banner, PictureUploader
  attr_accessor :logo_cache, :banner_cache

  belongs_to :brandable, polymorphic: true

  validates_with HexValidator, attributes: [:bg_color,
                                            :text_color,
                                            :content_bg_color,
                                            :content_text_color,
                                            :button_color,
                                            :button_text_color]

  def to_s
    I18n.t("activerecord.attributes.brand.for", name: brandable)
  end
end
