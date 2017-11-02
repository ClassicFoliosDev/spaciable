# frozen_string_literal: true

module ApplianceTabsHelper
  include TabsHelper

  def appliance_tabs(_parent, current_tab)
    tabs = APPLIANCE_TABS.call
    Tabs.new(Appliance.new, tabs, current_tab, self).all
  end

  APPLIANCE_TABS = lambda do
    {
      appliances: {
        icon: :coffee,
        link: ["appliances", active_tab: :appliances],
        permissions_on: -> { Appliance.new }
      },
      appliance_categories: {
        icon: "folder-o",
        link: ["appliance_categories", active_tab: :appliance_categories],
        permissions_on: -> { Appliance.new }
      },
      appliance_manufacturers: {
        icon: :industry,
        link: ["appliance_manufacturers", active_tab: :appliance_manufacturers],
        permissions_on: -> { Appliance.new }
      }
    }
  end
end
