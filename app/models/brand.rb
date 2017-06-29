# frozen_string_literal: true
class Brand < ApplicationRecord
  include ActiveModel::Validations

  mount_uploader :logo, PictureUploader
  mount_uploader :banner, PictureUploader
  mount_uploader :login_image, PictureUploader
  attr_accessor :logo_cache, :banner_cache, :login_image_cache
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

  def branded_header_color
    branded_param(:header_color)
  end

  def to_s
    I18n.t("activerecord.attributes.brand.for", name: brandable)
  end

  def branded_logo
    branded_param(:logo)
  end

  def branded_banner
    branded_param(:banner)
  end

  def branded_login_image
    branded_param(:login_image)
  end

  private

  def branded_param(attr_name)
    return self[attr_name] if self[attr_name]

    brand_parent = brandable
    while brand_parent.respond_to?(:parent)
      brand_parent = brand_parent.parent
      next unless brand_parent.brand
      return brand_parent.brand[attr_name] if brand_parent.brand[attr_name]
    end
  end
end
