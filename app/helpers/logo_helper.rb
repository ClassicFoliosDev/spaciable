# frozen_string_literal: true

module LogoHelper
  def login_brand_or_white_logo(brand)
    brand&.branded_login_logo ? brand.branded_login_logo : brand_or_white_logo(brand)
  end

  def brand_or_white_logo(brand)
    brand&.branded_logo ? brand.branded_logo : "hoozzi-everything-home-logo-white.svg"
  end

  def brand_or_red_logo(brand, plot)
    if plot.expired?
      "logo.png"
    else
      brand&.branded_logo ? brand.branded_logo : "logo.png"
    end
  end
end
