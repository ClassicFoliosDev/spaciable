# frozen_string_literal: true

module Admin
  module AnalyticsHelper
    def plot_type_collection
      [%w[Res&Comp all], %w[Reservation res], %w[Completion comp], %w[Created created], %w[Expired expired]]
    end
  end
end
