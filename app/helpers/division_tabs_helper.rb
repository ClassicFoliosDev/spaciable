# frozen_string_literal: true

module DivisionTabsHelper
  include TabsHelper
  include FaqTabsHelper

  def division_tabs(division, current_tab)
    tabs = DIVISION_TABS.call(division, FaqMenuBuilder.new)
    Tabs.new(division, tabs, current_tab, self).all
  end

  DIVISION_TABS = lambda do |division, faqmenubuilder|
    {
      developments: {
        icon: :building,
        link: [division.parent, division, active_tab: :developments],
        permissions_on: -> { division }
      },
      documents: {
        icon: "file-pdf-o",
        link: [division.parent, division, active_tab: :documents]
      },
      contacts: { icon: :vcard },
      faqs: {
        icon: "question-circle",
        menus: faqmenubuilder.menus_for(division)
      },
      brands: { icon: "css3" },
      videos: { icon: "file-video-o" },
      content_management: {
        icon: "clock-o",
        permissions_on: -> { division }
      }
    }
  end
end
