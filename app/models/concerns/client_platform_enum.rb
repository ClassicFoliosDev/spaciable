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

  def platform?(*platforms)
    platforms.each { |p| return true if platform_is?(p) }
    false
  end
end
