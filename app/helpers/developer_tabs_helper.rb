# frozen_string_literal: true
module DeveloperTabsHelper
  include TabsHelper

  def developer_tabs(developer, current_tab)
    tabs = DEVELOPER_TABS.call(developer)
    Tabs.new(developer, tabs, current_tab, self).all
  end

  DEVELOPER_TABS = lambda do |developer|
    {
      divisions: {
        icon: :building,
        link: [developer, active_tab: :divisions],
        permissions_on: -> { developer }
      },
      developments: {
        icon: :building,
        link: [developer, active_tab: :developments],
        permissions_on: -> { developer }
      },
      documents: {
        icon: "file-pdf-o",
        link: [developer, active_tab: :documents]
      },
      contacts: { icon: :vcard },
      faqs: { icon: "question-circle" },
      brands: { icon: "css3" }
    }
  end
end
