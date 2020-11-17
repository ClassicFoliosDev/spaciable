# frozen_string_literal: true

module CustomTileHelper
  def tile_collection(tag, meta: :undef, meta_val: nil)
    CustomTile.send(tag).map do |(tag_name, _)|
      [t(tag_name, scope: "activerecord.attributes.custom_tiles.#{tag}",
                   meta => meta_val), tag_name]
    end
  end

  def feature_disabled(custom_tile)
    disabled = []
    p = custom_tile.parent

    { "area_guide" => p.house_search, "services" => p.enable_services,
      "home_designer" => p.enable_roomsketcher, "issues" => p.maintenance,
      "referrals" => p.enable_referrals, "perks" => p.enable_perks,
      "snagging" => p.enable_snagging, "timeline" => p.timeline }.each do |name, feature|
      disabled << name unless feature
    end

    disabled
  end
end
