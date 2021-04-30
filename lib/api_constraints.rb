# frozen_string_literal: true

class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    @default || req.headers["Accept"].include("spaciable.api.v#{@version}")
  end
end
