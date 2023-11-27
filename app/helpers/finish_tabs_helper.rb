# frozen_string_literal: true

module FinishTabsHelper
  include TabsHelper

  def finish_tabs(_parent, current_tab, developer_id)
    tabs = FINISH_TABS.call(developer_id)
    Tabs.new(Finish.new(developer_id: developer_id), tabs, current_tab, self).all
  end

  FINISH_TABS = lambda do |developer_id|
    {
      finishes: {
        icon: :shower,
        link: [:finishes, active_tab: :finishes],
        permissions_on: -> { Finish.new(developer_id: developer_id) }
      },
      finish_categories: {
        icon: "folder-o",
        link: [:finish_categories, active_tab: :finish_categories],
        permissions_on: -> { Finish.new(developer_id: developer_id) },
        hide: !RequestStore.store[:current_user].cf_admin?
      },
      finish_types: {
        icon: "folder-o",
        link: [:finish_types, active_tab: :finish_types],
        permissions_on: -> { Finish.new(developer_id: developer_id) },
        hide: !RequestStore.store[:current_user].cf_admin?
      },
      finish_manufacturers: {
        icon: :industry,
        link: [:finish_manufacturers, active_tab: :finish_manufacturers],
        permissions_on: -> { Finish.new(developer_id: developer_id) }
      }
    }
  end
end
