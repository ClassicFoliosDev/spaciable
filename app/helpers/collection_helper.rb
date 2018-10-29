# frozen_string_literal: true

module CollectionHelper
  def render_collection(collection, **options)
    path = options.delete(:path)

    path ||= "#{options[:path_prefix]}/#{collection_path(collection)}"
    render path, options.merge(collection: collection)
  end

  def collection_path(collection)
    collection.model_name.route_key + "/collection"
  end

  def unit_type_collection(parent)
    parent.unit_types.pluck(:name, :id)
  end
end
