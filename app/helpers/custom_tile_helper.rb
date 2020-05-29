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
      "snagging" => p.enable_snagging }.each do |name, feature|
      disabled << name unless feature
    end

    disabled
  end

  def manual_unassigned(custom_tile)
    documents = collect_documents(custom_tile.parent)

    unassigned = %w[reservation completion]
    if documents.size.positive?
      documents.flatten!.each do |document|
        unassigned.delete(document.guide) if document.guide
        # stop checking documents if array is empty
        break if unassigned.empty?
      end
    end
    unassigned
  end

  private

  def collect_documents(parent)
    documents = []

    # gather documents for all descendants under the parent
    # e.g. if parent is a development, descendants will be all phases under the development,
    # and all plots under each of the phases
    parent.descendants.each do |descendant|
      documents << descendant.documents
    end

    # parent documents
    documents << parent.documents

    documents
  end
end
