# frozen_string_literal: true
module DivisionTabsHelper
  include TabsHelper

  # rubocop:disable MethodLength
  # Method is long but readable, refactoring shorter is likely to obfuscate
  def division_tabs(division, current_tab)
    developments_tab = Tab.new(
      title: t("developers.collection.developments"),
      icon: :building,
      link: developer_division_path(division.parent, division, active_tab: :developments),
      active: (current_tab == "developments")
    )

    contacts_tab = Tab.new(
      title: t("developers.collection.contacts"),
      icon: :vcard,
      link: division_contacts_path(division),
      active: (current_tab == "contacts")
    )

    division_brands_tab = Tab.new(
      title: t("developers.collection.brands"),
      icon: "css3",
      link: division_brands_path(division),
      active: (current_tab == "brands")
    )

    division_tabs = [developments_tab, contacts_tab].map(&:to_a)
    division_tabs.push(division_brands_tab.to_a) if can? :read, Brand
    division_tabs
  end
  # rubocop:enable MethodLength
end
