# frozen_string_literal: true

module ApplianceTabsHelper
  include TabsHelper

  def appliance_tabs(_parent, current_tab, developer_id)
    tabs = APPLIANCE_TABS.call(developer_id)
    Tabs.new(Appliance.new(developer_id: developer_id), tabs, current_tab, self).all
  end

  APPLIANCE_TABS = lambda do |developer_id|
    {
      appliances: {
        icon: :coffee,
        link: ["appliances", active_tab: :appliances],
        permissions_on: -> { Appliance.new(developer_id: developer_id) }
      },
      appliance_categories: {
        icon: "folder-o",
        link: ["appliance_categories", active_tab: :appliance_categories],
        permissions_on: -> { Appliance.new(developer_id: developer_id) }
      },
      appliance_manufacturers: {
        icon: :industry,
        link: ["appliance_manufacturers", active_tab: :appliance_manufacturers],
        permissions_on: -> { Appliance.new(developer_id: developer_id) }
      }
    }
  end
end
