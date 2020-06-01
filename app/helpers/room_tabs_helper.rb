# frozen_string_literal: true

module RoomTabsHelper
  include TabsHelper

  def room_tabs(room, current_tab, plot)
    tabs = ROOM_TABS.call(room, plot)
    Tabs.new(room, tabs, current_tab, self).all
  end

  ROOM_TABS = lambda do |room, plot|
    {
      finishes: {
        icon: :shower,
        link: [room.parent, room, active_tab: :finishes, plot: plot],
        always_show: true
      },
      appliances: {
        icon: :plug,
        link: [room.parent, room, active_tab: :appliances, plot: plot],
        always_show: true
      }
    }
  end
end
