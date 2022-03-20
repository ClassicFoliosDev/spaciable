# frozen_string_literal: true

module SpotlightHelper
  def visible_to_free(spotlight)
    return false unless spotlight.cf?
    spotlight.custom_tiles.each do |tile|
      return false if %w[home_designer perks snagging].include?(tile.feature)
    end
    true
  end
end
