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
        link: [plot.parent, plot, active_tab: :rooms],
        permissions_on: -> { plot.development.rooms.build }
      },
      residents: {
        icon: :building,
        link: [plot.parent, plot, active_tab: :residents]
      }
    }
  end
end
