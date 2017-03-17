# frozen_string_literal: true
module RoomTabsHelper
  include TabsHelper

  def room_tabs(room, current_tab)
    tabs = ROOM_TABS.call(room)
    Tabs.new(room, tabs, current_tab, self).all
  end

  ROOM_TABS = lambda do |room|
    {
      finishes: {
        icon: :building,
        link: [room.parent, room, active_tab: :finishes],
        always_show: true
      },
      appliances: {
        icon: :building,
        link: [room.parent, room, active_tab: :appliances],
        always_show: true
      }
    }
  end
end
