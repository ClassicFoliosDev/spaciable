# frozen_string_literal: true

module Admin
  module PlotSelectOptionsHelper
    # rubocop:disable Naming/MemoizedInstanceVariableName, Rails/HelperInstanceVariable
    def admin_plot_select_options(scope:)
      @plots ||= scope.plots.accessible_by(current_ability)
                      .select(:number, :id).map do |plot|
        [plot.to_s, plot.id]
      end
    end
    # rubocop:enable Naming/MemoizedInstanceVariableName, Rails/HelperInstanceVariable
  end
end
