# frozen_string_literal: true
module DivisionTabsHelper
  include TabsHelper

  def division_tabs(division, current_tab)
    tabs = DIVISION_TABS.call(division)
    Tabs.new(division, tabs, current_tab, self).all
  end

  DIVISION_TABS = lambda do |division|
    {
      developments: {
        icon: :building,
        link: [division.parent, division, active_tab: :developments],
        permissions_on: -> { division }
      },
      contacts: { icon: :vcard },
      faqs: { icon: "question-circle" },
      brands: { icon: "css3" }
    }
  end
end
