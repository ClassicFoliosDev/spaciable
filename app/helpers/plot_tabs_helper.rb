# frozen_string_literal: true
module PlotTabsHelper
  include TabsHelper

  def plot_tabs(plot, current_tab)
    tabs = PLOT_TABS.call(plot)
    Tabs.new(plot, tabs, current_tab, self).all
  end

  PLOT_TABS = lambda do |plot|
    {
      rooms: {
        icon: :building,
        link: [plot, active_tab: :rooms],
        permissions_on: -> { plot.development.rooms.build }
      },
      plot_residency: {
        icon: :user,
        link: [plot, :plot_residencies],
        permissions_on: -> { PlotResidency.new(plot_id: plot.id) }
      }
    }
  end
end
