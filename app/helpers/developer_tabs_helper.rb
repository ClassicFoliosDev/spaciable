# frozen_string_literal: true
module DeveloperTabsHelper
  include TabsHelper

  def developer_tabs(developer, current_tab)
    divisions_tab = Tab.new(
      title: t("developers.collection.divisions"),
      icon: :building,
      link: developer_path(developer, active_tab: :divisions),
      active: (current_tab == "divisions")
    )

    developments_tab = Tab.new(
      title: t("developers.collection.developments"),
      icon: :building,
      link: developer_path(developer, active_tab: :developments),
      active: (current_tab == "developments")
    )

    [divisions_tab, developments_tab].map(&:to_a)
  end
end
