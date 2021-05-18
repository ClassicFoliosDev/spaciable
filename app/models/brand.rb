# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class Brand < ApplicationRecord
  include Webhook::Observable
  include ActiveModel::Validations

  mount_uploader :logo, PictureUploader
  mount_uploader :banner, PictureUploader
  mount_uploader :login_image, PictureUploader
  mount_uploader :login_logo, PictureUploader
  mount_uploader :email_logo, PictureUploader
  attr_accessor :logo_cache, :banner_cache,
                :login_image_cache, :login_logo_cache, :email_logo_cache

  delegate :url, to: :banner, prefix: true
  delegate :url, to: :logo, prefix: true
  delegate :url, to: :login_image, prefix: true
  delegate :url, to: :login_logo, prefix: true
  delegate :url, to: :email_logo, prefix: true

  belongs_to :brandable, polymorphic: true

  validates_with HexValidator, attributes: %i[bg_color
                                              text_color
                                              content_bg_color
                                              content_text_color
                                              button_color
                                              button_text_color
                                              login_box_left_color
                                              login_box_right_color
                                              login_button_static_color
                                              login_button_hover_color
                                              content_box_text
                                              content_box_color
                                              content_box_outline_color
                                              text_left_color
                                              text_right_color]

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

  def branded_topnav_text_color
    branded_param(:topnav_text_color)
  end

  def branded_login_box_left_color
    branded_param(:login_box_left_color)
  end

  def branded_login_box_right_color
    branded_param(:login_box_right_color)
  end

  def branded_login_button_static_color
    branded_param(:login_button_static_color)
  end

  def branded_login_button_hover_color
    branded_param(:login_button_hover_color)
  end

  def branded_content_box_color
    branded_param(:content_box_color)
  end

  def branded_content_box_outline_color
    branded_param(:content_box_outline_color)
  end

  def branded_content_box_text
    branded_param(:content_box_text)
  end

  def branded_text_left_color
    branded_param(:text_left_color)
  end

  def branded_text_right_color
    branded_param(:text_right_color)
  end

  def branded_heading_one
    branded_param(:heading_one)
  end

  def branded_heading_two
    branded_param(:heading_two)
  end

  def branded_info_text
    branded_param(:info_text)
  end

  def to_s
    I18n.t("activerecord.attributes.brand.for", name: brandable)
  end

  def branded_logo
    branded_image(:logo_url)
  end

  def branded_login_logo
    branded_image(:login_logo_url)
  end

  def branded_banner
    branded_image(:banner_url)
  end

  def branded_login_image
    branded_image(:login_image_url)
  end

  def branded_email_logo
    branded_image(:email_logo_url)
  end

  def logo_thumb_url
    return unless logo
    return unless logo.file

    return logo.url if logo.file.extension.casecmp("svg").zero?

    logo.url :thumbnail
  end

  def custom_text?(brand)
    brand&.branded_heading_one || brand&.branded_heading_two || brand&.branded_info_text
  end

  # DEFAULT BRANDING COLOURS FOR USE IN BRANDED AND EXPIRED STYLING

  # Internal Styling

  def self.branded_body_default
    "background-color: #FFFFFF; // $ui-white;"
  end

  def self.branded_header_default
    "background-color: #002A3A; // $primary-navy;"
  end

  def self.branded_primary_default
    "color: #FF293F !important; // $primary-red-left;"
  end

  def self.branded_secondary_default
    "color: #002A3A; // $primary-navy;"
  end

  def self.branded_primary_text_default
    "color: #FFFFFF; // $ui-white;"
  end

  def self.branded_text_default
    "color: #002A3A // $primary-navy;"
  end

  def self.branded_content_default
    "background-color: #FFFFFF; // $ui-white;"
  end

  def self.branded_border_default
    "border-color: #c5d1d6; // $pale-navy;"
  end

  def self.branded_top_header_default
    "color: #002A3A; // $primary-navy;"
  end

  def self.branded_second_header_default
    "color: #FF293F; // $primary-red-left;"
  end

  # Buttons

  def self.branded_static_background_default
    "background-color: #FFFFFF; // $ui-white;"
  end

  def self.branded_static_text_default
    "color: #FF293F; // $primary-red-left;"
  end

  def self.branded_static_border_default
    "border-color: #FF293F; // $primary-red-left;"
  end

  def self.branded_hover_background_default
    "background-color: #FF293F; // $primary-red-left;"
  end

  def self.branded_hover_text_default
    "color: #FFFFFF; // $ui-white;"
  end

  def self.branded_hover_border_default
    "border-color: #FFFFFF; // $ui-white;"
  end

  def self.branded_login_text_default
    "color: #FF293F; // $primary-red-left;"
  end

  def self.branded_login_border_default
    "border-color: #FF293F; // $primary-red-left;"
  end

  # Input Fields

  def self.branded_autofill_default
    "-webkit-box-shadow: 0 0 0 30px #FFFFFF inset; // $ui-white;"
  end

  def self.branded_autofill_text_default
    "-webkit-text-fill-color: #000000;"
  end

  def self.branded_input_background_default
    "background-color: #FFFFFF; // $ui-white;"
  end

  def self.branded_input_text_default
    "color: #000000;"
  end

  def self.branded_input_border_default
    "border-color: #FF293F; // $primary-red-left;"
  end

  def self.branded_checkbox_untick_default
    "color: #FFFFFF; // $ui-white;"
  end

  def self.branded_checkbox_tick_default
    "color: #FF293F; // $primary-red-left;"
  end

  # External Styling

  def self.branded_left_box_default
    "background-color: #F4F4F4; // $ui-white;"
  end

  def self.branded_right_box_default
    "background-color: #FFFFFF; // $ui-white;"
  end

  def self.branded_external_text_default
    "color: #002A3A; // $primary-navy;"
  end

  def self.branded_left_text_default
    "color: #67747C; // $type-grey;"
  end

  def self.branded_second_heading_default
    "color: #FF293F; // $primary-red-left;"
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

  def webhook_payload
    attribs = attributes
    %w[logo banner login_image login_logo email_logo].each do |field|
      attribs[field] = Webhook::Stream.image(send(field), send("#{field}_before_type_cast"))
    end

    attribs
  end
end
# rubocop:enable Metrics/ClassLength
