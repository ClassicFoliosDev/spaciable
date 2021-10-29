# frozen_string_literal: true

module CustomTilesHelper
  def visible_tiles(custom_tiles, plot)
    return custom_tiles unless plot.free?
    custom_tiles.reject! { |ct| ct.perks? || ct.home_designer? }
  end
end
