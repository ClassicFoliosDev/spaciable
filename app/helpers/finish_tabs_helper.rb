# frozen_string_literal: true
module FinishTabsHelper
  include TabsHelper

  def finish_tabs(_parent, current_tab)
    tabs = FINISH_TABS.call
    Tabs.new(Finish.new, tabs, current_tab, self).all
  end

  FINISH_TABS = lambda do
    {
      finishes: {
        icon: :shower,
        link: ["finishes", active_tab: :finishes],
        permissions_on: -> { Finish.new }
      },
      finish_categories: {
        icon: "folder-o",
        link: ["finish_categories", active_tab: :finish_categories],
        permissions_on: -> { Finish.new }
      },
      finish_types: {
        icon: "folder-o",
        link: ["finish_types", active_tab: :finish_types],
        permissions_on: -> { Finish.new }
      },
      finish_manufacturers: {
        icon: :industry,
        link: ["finish_manufacturers", active_tab: :finish_manufacturers],
        permissions_on: -> { Finish.new }
      }
    }
  end
end
