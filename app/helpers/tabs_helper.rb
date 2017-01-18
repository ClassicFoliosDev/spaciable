# frozen_string_literal: true
module TabsHelper
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

  # rubocop:disable MethodLength
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

    [unit_types_tab, phases_tab, plots_tab].map(&:to_a)
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

    [unit_types_tab, phases_tab, plots_tab].map(&:to_a)
  end
  # rubocop:enable MethodLength

  def room_tabs(room, current_tab)
    finishes_tab = Tab.new(
      title: t("rooms.collection.finishes"),
      icon: :building,
      link: room_path(room, active_tab: :finishes),
      active: (current_tab == "finishes")
    )

    appliances_tab = Tab.new(
      title: t("rooms.collection.appliances"),
      icon: :building,
      link: room_path(room, active_tab: :appliances),
      active: (current_tab == "appliances")
    )

    [finishes_tab, appliances_tab].map(&:to_a)
  end

  class Tab
    attr_reader :title, :icon, :link, :active

    def initialize(title:, icon:, link:, active:)
      @title = title
      @icon = icon
      @link = link
      @active = active
    end

    def active?
      active == true
    end

    def to_a
      [title, icon, link, active?]
    end
  end
end
