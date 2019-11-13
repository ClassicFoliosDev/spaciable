# frozen_string_literal: true

module Admin
  module AnalyticsHelper
    def plot_type_collection
      [%w[All all], %w[Reservation res], %w[Completion comp]]
    end
  end
end
