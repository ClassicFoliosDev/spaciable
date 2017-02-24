# frozen_string_literal: true
module UnitTypeTabsHelper
  include TabsHelper

  def unit_type_tabs(unit_type, current_tab)
    tabs = UNIT_TYPE_TABS.call(unit_type)
    Tabs.new(unit_type, tabs, current_tab, self).all
  end

  UNIT_TYPE_TABS = lambda do |unit_type|
    {
      rooms: {
        icon: :bath,
        link: [unit_type.parent, unit_type, active_tab: :rooms],
        permissions_on: -> { unit_type.rooms.build }
      },
      documents: {
        icon: "file-pdf-o",
        link: [unit_type.parent, unit_type, active_tab: :documents]
      }
    }
  end
end
