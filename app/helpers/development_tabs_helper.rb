# frozen_string_literal: true
module DevelopmentTabsHelper
  include TabsHelper

  # rubocop:disable MethodLength
  # rubocop:disable Metrics/AbcSize
  # Method is long but readable, refactoring shorter is likely to obfuscate
  def development_tabs(development, current_tab)
    unit_types_tab = Tab.new(
      title: t("developments.collection.unit_types"),
      icon: :building,
      link: [development.parent, development, active_tab: :unit_types],
      active: (current_tab == "unit_types")
    )

    phases_tab = Tab.new(
      title: t("developments.collection.phases"),
      icon: :building,
      link: [development.parent, development, active_tab: :phases],
      active: (current_tab == "phases")
    )

    plots_tab = Tab.new(
      title: t("developments.collection.plots"),
      icon: :building,
      link: [development.parent, development, active_tab: :plots],
      active: (current_tab == "plots")
    )

    contacts_tab = Tab.new(
      title: t("developers.collection.contacts"),
      icon: :vcard,
      link: development_contacts_path(development),
      active: (current_tab == "contacts")
    )

    development_brands_tab = Tab.new(
      title: t("developers.collection.brands"),
      icon: "css3",
      link: development_brands_path(development),
      active: (current_tab == "brands")
    )

    development_tabs = [unit_types_tab, phases_tab, plots_tab, contacts_tab].map(&:to_a)
    development_tabs.push(development_brands_tab.to_a) if can? :read, Brand
    development_tabs
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable MethodLength
end
