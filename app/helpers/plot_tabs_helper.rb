# frozen_string_literal: true

module PlotTabsHelper
  include TabsHelper

  def plot_tabs(plot, current_tab, current_user)
    tabs = PLOT_TABS.call(plot, current_user)
    Tabs.new(plot, tabs, current_tab, self).all
  end

  # rubocop:disable BlockLength
  PLOT_TABS = lambda do |plot, current_user|
    {
      documents: {
        icon: "file-pdf-o", link: [plot, active_tab: :documents]
      },
      rooms: {
        icon: :bath, link: [plot, active_tab: :rooms],
        permissions_on: -> { plot.development.rooms.build }
      },
      logs: {
        icon: :pencil, link: [plot, active_tab: :logs],
        permissions_on: -> { plot },
        hide: plot.hide_logs?
      },
      residents: {
        icon: :user, link: [plot, active_tab: :residents],
        permissions_on: -> { PlotResidency.new(plot_id: plot.id) }
      },
      progress: {
        icon: "cogs", link: [plot, active_tab: :progress],
        permissions_on: -> { plot }
      },
      completion: {
        icon: "calendar", link: [plot, active_tab: :completion],
        permissions_on: -> { plot }
      },
      choices: {
        icon: "th-list",
        permissions_on: -> { plot },
        hide: !plot.choices?(current_user)
      },
      calendar: {
        icon: "calendar", link: [plot, active_tab: :calendar],
        permissions_on: -> { plot }
      }
    }
  end
  # rubocop:enable BlockLength
end
