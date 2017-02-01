# frozen_string_literal: true
module DivisionTabsHelper
  include TabsHelper

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

    [developments_tab, contacts_tab].map(&:to_a)
  end
end
