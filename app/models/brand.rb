# frozen_string_literal: true
class Brand < ApplicationRecord
  include ActiveModel::Validations

  mount_uploader :logo, PictureUploader
  mount_uploader :banner, PictureUploader
  attr_accessor :logo_cache, :banner_cache
  process_in_background :logo
  process_in_background :banner

  belongs_to :brandable, polymorphic: true

  validates_with HexValidator, attributes: [:bg_color,
                                            :text_color,
                                            :content_bg_color,
                                            :content_text_color,
                                            :button_color,
                                            :button_text_color]

  def branded_text_color
    branded_param(:text_color)
  end

  def branded_bg_color
    branded_param(:bg_color)
  end

  def branded_content_bg_color
    branded_param(:content_bg_color)
  end

  def branded_content_text_color
    branded_param(:content_text_color)
  end

  def branded_button_color
    branded_param(:button_color)
  end

  def branded_button_text_color
    branded_param(:button_text_color)
  end

  def to_s
    I18n.t("activerecord.attributes.brand.for", name: brandable)
  end

  def branded_logo
    return logo.url if logo.url.present?

    brand_parent = brandable
    while brand_parent.respond_to?(:parent)
      brand_parent = brand_parent.parent
      return brand_parent.brand.logo.url if brand_parent.brand.logo.url.present?
    end
  end

  def branded_banner
    return banner.url if banner.url.present?

    brand_parent = brandable
    while brand_parent.respond_to?(:parent)
      brand_parent = brand_parent.parent
      return brand_parent.brand.banner.url if brand_parent.brand.banner.url.present?
    end
  end

  private

  def branded_param(attr_name)
    return self[attr_name] if self[attr_name].present?

    brand_parent = brandable
    while brand_parent.respond_to?(:parent)
      brand_parent = brand_parent.parent
      return brand_parent.brand[attr_name] if brand_parent.brand[attr_name].present?
    end
  end
end
