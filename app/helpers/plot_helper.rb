# frozen_string_literal: false

module PlotHelper
  def occupied_status(plot)
    "plot-occupancy #{Plot::OCCUPATION_STATUS.key(plot.occupancy?)} fa fa-user"
  end
end
