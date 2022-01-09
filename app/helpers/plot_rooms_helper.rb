# frozen_string_literal: true

module PlotRoomsHelper
  def no_plot_rooms(plot)
    return "plots/rooms/empty_completed" if current_user.cf_admin? ||
                                            (!plot.free? && plot.cas &&
                                              plot.completion_release_date.present?)
    return "plots/rooms/empty_not_completed" if plot.cas
    nil
  end

  def plot_development_path(plot)
    return division_development_path(plot.division, plot.development) if plot.division.present?
    developer_development_path(plot.developer, plot.development)
  end
end
