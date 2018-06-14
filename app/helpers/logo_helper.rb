# frozen_string_literal: true

module LogoHelper
  def brand_or_white_logo(brand)
    brand&.branded_logo ? brand.branded_logo : "ISYT_white.png"
  end

  def brand_or_red_logo(brand)
    brand&.branded_logo ? brand.branded_logo : "ISYT-40px-01.png"
  end
end
