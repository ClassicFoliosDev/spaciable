# frozen_string_literal: true

module PhaseTabsHelper
  include TabsHelper

  def phase_tabs(phase, current_tab, current_user)
    tabs = PHASE_TABS.call(phase, current_user)
    Tabs.new(phase, tabs, current_tab, self).all
  end

  # rubocop:disable BlockLength
  PHASE_TABS = lambda do |phase, current_user|
    {
      production: {
        icon: :superpowers,
        link: [phase.parent, phase, active_tab: :production],
        # Only a CF admin can create appliances and use the production tab
        permissions_on: -> { Appliance.new }
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
      progresses: {
        icon: "cogs",
        link: [phase, :progresses],
        permissions_on: -> { Plot.new(development_id: phase.development.id) }
      },
      bulk_edit: {
        icon: "pencil-square-o",
        link: [phase, :bulk_edit_index],
        # Only a CF admin can create appliances and make bulk edits
        permissions_on: -> { Appliance.new }
      },
      release_plots: {
        icon: "rocket",
        link: [phase, :release_plots],
        # Only a CF admin can create appliances and make bulk edits
        permissions_on: -> { Appliance.new }
      },
      # PLANET RENT API
      lettings: {
        icon: "calendar-o",
        link: [phase, :lettings],
        permissions_on: -> { phase },
        hide: !(current_user.cf_admin? || current_user.branch?)
      }
    }
  end
  # rubocop:enable BlockLength
end
