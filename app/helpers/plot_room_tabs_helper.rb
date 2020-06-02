# frozen_string_literal: true

module PlotRoomTabsHelper
  include TabsHelper

  def plot_room_tabs(room, current_tab, plot)
    tabs = ROOM_TABS.call(room, plot)
    Tabs.new(room, tabs, current_tab, self).all
  end

  ROOM_TABS = lambda do |room, plot|
    {
      finishes: {
        icon: :shower,
        link: [plot, room, active_tab: :finishes, plot: plot],
        always_show: true
      },
      appliances: {
        icon: :plug,
        link: [plot, room, active_tab: :appliances, plot: plot],
        always_show: true
      }
    }
  end
end
