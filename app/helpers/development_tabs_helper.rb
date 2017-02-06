# frozen_string_literal: true
module DevelopmentTabsHelper
  include TabsHelper

  def development_tabs(development, current_tab)
    tabs = DEVELOPMENT_TABS.call(development)
    Tabs.new(development, tabs, current_tab, self).all
  end

  DEVELOPMENT_TABS = lambda do |development|
    {
      unit_types: {
        icon: :building,
        link: [development.parent, development, active_tab: :unit_types]
      },
      phases: {
        icon: :building,
        link: [development.parent, development, active_tab: :phases]
      },
      plots: {
        icon: :building,
        link: [development.parent, development, active_tab: :plots]
      },
      faqs: { icon: "question-circle" },
      contacts: { icon: :vcard },
      brands: { icon: "css3" }
    }
  end
end
