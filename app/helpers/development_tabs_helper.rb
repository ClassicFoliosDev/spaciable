# frozen_string_literal: true
module DevelopmentTabsHelper
  include TabsHelper

  # rubocop:disable MethodLength
  # Method is long but readable, refactoring shorter is likely to obfuscate
  def developer_development_tabs(developer, current_tab)
    unit_types_tab = Tab.new(
      title: t("developments.collection.unit_types"),
      icon: :building,
      link: developer_development_path(developer, active_tab: :unit_types),
      active: (current_tab == "unit_types")
    )

    phases_tab = Tab.new(
      title: t("developments.collection.phases"),
      icon: :building,
      link: developer_development_path(developer, active_tab: :phases),
      active: (current_tab == "phases")
    )

    plots_tab = Tab.new(
      title: t("developments.collection.plots"),
      icon: :building,
      link: developer_development_path(developer, active_tab: :plots),
      active: (current_tab == "plots")
    )

    contacts_tab = Tab.new(
      title: t("developers.collection.contacts"),
      icon: :vcard,
      link: developer_development_path(developer, active_tab: :contacts),
      active: (current_tab == "contacts")
    )

    [unit_types_tab, phases_tab, plots_tab, contacts_tab].map(&:to_a)
  end

  def division_development_tabs(division, current_tab)
    unit_types_tab = Tab.new(
      title: t("developments.collection.unit_types"),
      icon: :building,
      link: division_development_path(division, active_tab: :unit_types),
      active: (current_tab == "unit_types")
    )

    phases_tab = Tab.new(
      title: t("developments.collection.phases"),
      icon: :building,
      link: division_development_path(division, active_tab: :phases),
      active: (current_tab == "phases")
    )

    plots_tab = Tab.new(
      title: t("developments.collection.plots"),
      icon: :building,
      link: division_development_path(division, active_tab: :plots),
      active: (current_tab == "plots")
    )

    contacts_tab = Tab.new(
      title: t("developers.collection.contacts"),
      icon: :vcard,
      link: division_development_path(division, active_tab: :contacts),
      active: (current_tab == "contacts")
    )

    [unit_types_tab, phases_tab, plots_tab, contacts_tab].map(&:to_a)
  end
  # rubocop:enable MethodLength
end
