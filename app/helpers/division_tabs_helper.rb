# frozen_string_literal: true
module DivisionTabsHelper
  include TabsHelper

  def division_tabs(developer, current_tab)
    developments_tab = Tab.new(
      title: t("developers.collection.developments"),
      icon: :building,
      link: developer_division_path(developer, active_tab: :developments),
      active: (current_tab == "developments")
    )

    contacts_tab = Tab.new(
      title: t("developers.collection.contacts"),
      icon: :vcard,
      link: developer_division_path(developer, active_tab: :contacts),
      active: (current_tab == "contacts")
    )

    [developments_tab, contacts_tab].map(&:to_a)
  end
end
