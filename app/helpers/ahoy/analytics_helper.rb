# frozen_string_literal: true

module Ahoy
  module AnalyticsHelper
    def record_action(page, *params)
      ahoy.track page, *params
    end
  end
end
