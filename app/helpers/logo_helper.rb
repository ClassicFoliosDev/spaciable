# frozen_string_literal: true

module LogoHelper
  def logo_image_name(brand)
    brand&.branded_logo ? brand.branded_logo : "hoozzi-everything-home-logo-white.svg"
  end
end
