# frozen_string_literal: true

module DevelopmentTabsHelper
  include TabsHelper

  def development_tabs(development, current_tab)
    tabs = DEVELOPMENT_TABS.call(development)
    Tabs.new(development, tabs, current_tab, self).all
  end

  # rubocop:disable Metrics/BlockLength
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
      documents: {
        icon: "file-pdf-o",
        link: [development.parent, development, active_tab: :documents]
      },
      faqs: { icon: "question-circle" },
      contacts: { icon: :vcard },
      brands: { icon: "css3" },
      videos: { icon: "file-video-o" },
      choice_configurations: {
        icon: "th-list",
        hide: development.choices_disabled?,
        link: [development.parent, development, active_tab: :choice_configurations]
      },
      development_csv: {
        icon: "fighter-jet",
        check_assoc: true, # check phase for development_csv permission
        permissions_on: -> { development }
      },
      custom_tiles: { icon: "external-link-square" }
    }
  end
  # rubocop:enable Metrics/BlockLength
end
