# frozen_string_literal: true

module UnitTypeTabsHelper
  include TabsHelper

  def unit_type_tabs(unit_type, current_tab)
    tabs = UNIT_TYPE_TABS.call(unit_type)
    Tabs.new(unit_type, tabs, current_tab, self).all
  end

  UNIT_TYPE_TABS = lambda do |unit_type|
    {
      documents: {
        icon: "file-pdf-o",
        link: [unit_type.parent, unit_type, active_tab: :documents]
      },
      rooms: {
        icon: :bath,
        link: [unit_type, :rooms],
        always_show: true
      },
      logs: {
        icon: :pencil,
        link: [unit_type.parent, unit_type, active_tab: :logs],
        permissions_on: -> { unit_type },
        hide: !unit_type.cas
      }
    }
  end
end
