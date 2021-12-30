# frozen_string_literal: true

module DevelopmentTabsHelper
  include TabsHelper
  include FaqTabsHelper

  def development_tabs(development, current_tab,
                       current_user = RequestStore.store[:current_user])
    tabs = DEVELOPMENT_TABS.call(development, FaqMenuBuilder.new, current_user)
    Tabs.new(development, tabs, current_tab, self).all
  end

  # rubocop:disable Metrics/BlockLength
  DEVELOPMENT_TABS = lambda do |development, faqmenubuilder, current_user|
    {
      unit_types: {
        icon: :building,
        link: [development.parent, development, active_tab: :unit_types],
        hide: !current_user.cf_admin? && development.all_phases_free?
      },
      phases: {
        icon: :building,
        link: [development.parent, development, active_tab: :phases]
      },
      documents: {
        icon: "file-pdf-o",
        link: [development.parent, development, active_tab: :documents]
      },
      faqs: {
        icon: "question-circle",
        menus: faqmenubuilder.menus_for(development)
      },
      contacts: { icon: :vcard },
      brands: { icon: "css3" },
      videos: { icon: "file-video-o" },
      choice_configurations: {
        icon: "th-list",
        hide: development.choices_disabled?,
        link: [development.parent, development, active_tab: :choice_configurations]
      },
      development_csv: {
        icon: "file-excel-o",
        check_assoc: true, # check phase for development_csv permission
        permissions_on: -> { development },
        hide: !current_user.cf_admin? && development.all_phases_free?
      },
      custom_tiles: {
        icon: "external-link-square"
      },
      calendar: {
        icon: "calendar", link: [development, :calendars],
        permissions_on: -> { development },
        hide: !development.calendar
      }
    }
  end
  # rubocop:enable Metrics/BlockLength
end
