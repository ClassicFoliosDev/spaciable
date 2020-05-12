# frozen_string_literal: true

module CustomTileHelper
  def tile_category_collection(custom_tile)
    CustomTile.categories.map do |(category_name, _category_int)|
      [t(category_name, scope: tile_category_scope), category_name]
    end
  end

  def tile_feature_collection(custom_tile)
    CustomTile.features.map do |(feature_name, _feature_int)|
      [t(feature_name, scope: tile_feature_scope,
                       snag_name: custom_tile.snag_name), feature_name]
    end
  end

  def tile_guide_collection(custom_tile)
    CustomTile.guides.map do |(guide_name, _guide_int)|
      [t(guide_name, scope: tile_guide_scope), guide_name]
    end
  end

  def feature_disabled(custom_tile)
    disabled = []
    p = custom_tile.parent

    { 'area_guide' => p.house_search, 'services' => p.enable_services,
      'home_designer' => p.enable_roomsketcher, 'issues' => p.maintenance,
      'referrals' => p.enable_referrals, 'perks' => p.enable_perks,
      'snagging' => p.enable_snagging }.each do |name, feature|
      disabled << name unless feature
    end

    disabled
  end

  private

  def tile_category_scope
    "activerecord.attributes.custom_tiles.categories"
  end

  def tile_feature_scope
    "activerecord.attributes.custom_tiles.features"
  end

  def tile_guide_scope
    "activerecord.attributes.custom_tiles.guides"
  end

end
