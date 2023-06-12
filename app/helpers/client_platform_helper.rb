# frozen_string_literal: true

module ClientPlatformHelper
  def client_platform_collection
    Development.client_platforms.map do |(platform, _int)|
      [t(platform, scope: platform_label_scope), platform]
    end
  end

  private

  def platform_label_scope
    "activerecord.attributes.development.client_platform_labels"
  end
end
