# frozen_string_literal: true

class ChartColour < ApplicationRecord
  def self.colours
    @colours ||= ChartColour.all
  end

  enum key: %i[
    empty
    plots_with_activated_residents
    plots_with_invited_residents
    plots_not_invited
    invited_plots_pending_activation
    highest_activation
    lowest_activation
    placing_row
    hundred_percent
  ]
end
