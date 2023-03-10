# frozen_string_literal: true

module ClientPlatformEnum
  extend ActiveSupport::Concern

  included do
    enum client_platform: %i[
      native
      living
      hybrid
    ]
  end

  def platform_is?(type)
    client_platform == type.to_s
  end
end
