# frozen_string_literal: true
module PlotTabsHelper
  include TabsHelper

  def development_plot_tabs(development, current_tab)
    rooms_tab = Tab.new(
      title: t("plots.collection.rooms"),
      icon: :building,
      link: development_plot_path(development, active_tab: :rooms),
      active: (current_tab == "rooms")
    )

    residents_tab = Tab.new(
      title: t("plots.collection.residents"),
      icon: :building,
      link: development_plot_path(development, active_tab: :residents),
      active: (current_tab == "residents")
    )

    [rooms_tab, residents_tab].map(&:to_a)
  end

  def phase_plot_tabs(development, current_tab)
    rooms_tab = Tab.new(
      title: t("plots.collection.rooms"),
      icon: :building,
      link: phase_plot_path(development, active_tab: :rooms),
      active: (current_tab == "rooms")
    )

    residents_tab = Tab.new(
      title: t("plots.collection.residents"),
      icon: :building,
      link: phase_plot_path(development, active_tab: :residents),
      active: (current_tab == "residents")
    )
    [rooms_tab, residents_tab].map(&:to_a)
  end
end
