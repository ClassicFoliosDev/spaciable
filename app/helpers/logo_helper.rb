# frozen_string_literal: true

module LogoHelper
  def login_brand_or_white_logo(brand)
    brand&.branded_login_logo ? brand.branded_login_logo : brand_or_white_logo(brand)
  end

  def brand_or_white_logo(brand)
    brand&.branded_logo ? brand.branded_logo : "Spaciable_full.svg"
  end

  def brand_or_small_logo(brand, plot)
    if plot.expired?
      "Spaciable_icon.svg"
    else
      brand&.branded_logo ? brand.branded_logo : "Spaciable_icon.svg"
    end
  end

  def brand_or_red_logo(brand, plot)
    if plot.expired?
      "Spaciable_full.svg"
    else
      brand&.branded_logo ? brand.branded_logo : "Spaciable_full.svg"
    end
  end
end
