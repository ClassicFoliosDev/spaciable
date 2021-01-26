# frozen_string_literal: true

module FeatureHelper
  def feature_link(plot, feature)
    return feature.link if feature.feature_type.to_sym == :custom_url
    plot.feature_link(feature.feature_type)
  end
end
