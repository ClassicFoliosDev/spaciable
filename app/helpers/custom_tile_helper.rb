# frozen_string_literal: true

module CustomTileHelper
  def tile_collection(tag, meta: :undef, meta_val: nil)
    CustomTile.send(tag).map do |(tag_name, _)|
      [t(tag_name, scope: "activerecord.attributes.custom_tiles.#{tag}",
                   meta => meta_val), tag_name]
    end
  end
end
