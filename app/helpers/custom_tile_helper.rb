# frozen_string_literal: true

module CustomTileHelper
  def tile_collection(tag, meta: :undef, meta_val: nil, developer: nil)
    CustomTile.send(tag).filter_map do |(tag_name, _)|
      if CustomTile.supports(developer, tag_name)
        [t(tag_name, scope: "activerecord.attributes.custom_tiles.#{tag}",
                     meta => meta_val), tag_name]
      end
    end
  end
end
