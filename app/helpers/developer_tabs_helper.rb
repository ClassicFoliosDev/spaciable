# frozen_string_literal: true
module DeveloperTabsHelper
  include TabsHelper

  # rubocop:disable MethodLength
  # Method is long but readable, refactoring shorter is likely to obfuscate
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

    documents_tab = Tab.new(
      title: t("developers.collection.documents"),
      icon: :building,
      link: developer_path(developer, active_tab: :documents),
      active: (current_tab == "documents")
    )

    [divisions_tab, developments_tab, documents_tab].map(&:to_a)
  end
  # rubocop:enable MethodLength
end
