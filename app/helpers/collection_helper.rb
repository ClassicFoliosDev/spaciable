# frozen_string_literal: true
module CollectionHelper
  def render_collection(collection, **opts)
    path = "#{opts[:path_prefix]}/#{collection_path(collection)}"

    render path, opts.merge(collection: collection)
  end

  def collection_path(collection)
    collection.model_name.route_key + "/collection"
  end
end
