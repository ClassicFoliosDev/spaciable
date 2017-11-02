# frozen_string_literal: true

class Brand < ApplicationRecord
  include ActiveModel::Validations

  mount_uploader :logo, PictureUploader
  mount_uploader :banner, PictureUploader
  mount_uploader :login_image, PictureUploader
  attr_accessor :logo_cache, :banner_cache, :login_image_cache
  process_in_background :logo
  process_in_background :banner
  process_in_background :login_image

  delegate :url, to: :banner, prefix: true
  delegate :url, to: :logo, prefix: true
  delegate :url, to: :login_image, prefix: true

  belongs_to :brandable, polymorphic: true

  validates_with HexValidator, attributes: %i[bg_color
                                              text_color
                                              content_bg_color
                                              content_text_color
                                              button_color
                                              button_text_color]

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
    branded_image(:logo_url)
  end

  def branded_banner
    branded_image(:banner_url)
  end

  def branded_login_image
    branded_image(:login_image_url)
  end

  private

  def branded_param(attr_name)
    return self[attr_name] if self[attr_name].present?

    brand_parent = brandable
    while brand_parent.respond_to?(:parent)
      brand_parent = brand_parent.parent
      next unless brand_parent.brand
      return brand_parent.brand[attr_name] if brand_parent.brand[attr_name].present?
    end
  end

  def branded_image(attr_name_url)
    return send(attr_name_url) if send(attr_name_url)

    brand_parent = brandable
    while brand_parent.respond_to?(:parent)
      brand_parent = brand_parent.parent
      next unless brand_parent.brand
      return brand_parent.brand.send(attr_name_url) if brand_parent.brand.send(attr_name_url)
    end
  end
end
