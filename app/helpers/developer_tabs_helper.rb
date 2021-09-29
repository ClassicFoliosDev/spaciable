# frozen_string_literal: true

module DeveloperTabsHelper
  include TabsHelper
  include FaqTabsHelper

  def developer_tabs(developer, current_tab)
    tabs = DEVELOPER_TABS.call(developer, FaqMenuBuilder.new)
    Tabs.new(developer, tabs, current_tab, self).all
  end

  # rubocop:disable Metrics/BlockLength
  DEVELOPER_TABS = lambda do |developer, faqmenubuilder|
    {
      divisions: {
        icon: :building,
        link: [developer, active_tab: :divisions],
        permissions_on: -> { developer },
        hide: !RequestStore.store[:current_user].cf_admin? &&
          developer.divisions.empty?
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
      faqs: {
        icon: "question-circle",
        menus: faqmenubuilder.menus_for(developer)
      },
      brands: { icon: "css3" },
      branded_apps: {
        icon: "apple",
        permissions_on: -> { developer },
        hide: !developer.branded_app?
      },
      timelines: {
        icon: "clock-o",
        permissions_on: -> { developer },
        hide: !developer.timeline?
      },
      videos: { icon: "file-video-o" },
      content_management: {
        icon: "clock-o",
        permissions_on: -> { developer }
      }
    }
  end
  # rubocop:enable Metrics/BlockLength
end
