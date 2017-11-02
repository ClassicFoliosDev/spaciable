# frozen_string_literal: true

module Admin
  module PlotSelectOptionsHelper
    def admin_plot_select_options(scope:)
      @plots ||= scope.plots.accessible_by(current_ability)
                      .select(:prefix, :number, :id).map do |plot|
        [plot.to_s, plot.id]
      end
    end
  end
end
