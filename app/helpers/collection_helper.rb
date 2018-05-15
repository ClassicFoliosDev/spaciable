# frozen_string_literal: true

module CollectionHelper
  def render_collection(collection, **options)
    path = options.delete(:path)

    path ||= "#{options[:path_prefix]}/#{collection_path(collection)}"
    render path, options.merge(collection: collection)
  # We have a clone of production data in staging, so this error can be expected
  # in the staging environment: but don't swallow it in prod
  rescue Aws::S3::Errors::Forbidden
    raise if Rails.env.production?
    Rails.logger.debug("S3 forbidden error for #{path}")
  end

  def collection_path(collection)
    collection.model_name.route_key + "/collection"
  end
end
