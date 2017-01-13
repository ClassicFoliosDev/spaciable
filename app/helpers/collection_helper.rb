# frozen_string_literal: true
module CollectionHelper
  def render_collection(collection, **opts)
    render collection_path(collection), opts.merge(collection: collection)
  end

  def collection_path(collection)
    collection.model_name.route_key + "/collection"
  end
end
