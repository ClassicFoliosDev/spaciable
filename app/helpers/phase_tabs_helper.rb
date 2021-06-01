# frozen_string_literal: true

module PhaseTabsHelper
  include TabsHelper

  def phase_tabs(phase, current_tab,
                 current_user = RequestStore.store[:current_user])
    tabs = PHASE_TABS.call(phase, current_user)
    Tabs.new(phase, tabs, current_tab, self).all
  end

  # rubocop:disable BlockLength
  PHASE_TABS = lambda do |phase, current_user|
    {
      production: {
        icon: :superpowers,
        link: [phase.parent, phase, active_tab: :production],
        check_assoc: true, # check phase for production permission
        permissions_on: -> { phase }
      },
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
      contacts: { icon: :vcard },
      brands: { icon: "css3" },
      bulk_edit: {
        icon: "pencil-square-o",
        link: [phase, :bulk_edit_index],
        check_assoc: true, # check phase for bulk_edit permission
        permissions_on: -> { phase }
      },
      release_plots: {
        icon: "rocket",
        link: [phase, :release_plots],
        check_assoc: true, # check phase for release_plots permission
        permissions_on: -> { phase }
      },
      # PLANET RENT API
      lettings: {
        icon: "calendar-o",
        link: [phase, :lettings],
        permissions_on: -> { phase },
        hide: !(current_user.cf_admin? || current_user.branch?)
      },
      phase_timelines: {
        icon: "clock-o",
        link: [phase, :phase_timelines],
        permissions_on: -> { phase },
        hide: !phase.timeline
      },
      calendar: {
        icon: "calendar", link: [phase, :calendars],
        permissions_on: -> { phase },
        hide: !phase.development_calendar
      }
    }
  end
  # rubocop:enable BlockLength
end
