# frozen_string_literal: true

module PhaseTabsHelper
  include TabsHelper

  def phase_tabs(phase, current_tab)
    tabs = PHASE_TABS.call(phase)
    Tabs.new(phase, tabs, current_tab, self).all
  end

  PHASE_TABS = lambda do |phase|
    {
      plots: {
        icon: :building,
        link: [phase.parent, phase, active_tab: :plots],
        permissions_on: -> { phase }
      },
      plot_documents: {
        icon: "files-o",
        link: [phase, :plot_documents]
      },
      documents: {
        icon: "file-pdf-o",
        link: [phase.parent, phase, active_tab: :documents]
      },
      progresses: {
        icon: "cogs",
        link: [phase, :progresses],
        permissions_on: -> { Plot.new(development_id: phase.development.id) }
      }
    }
  end
end
