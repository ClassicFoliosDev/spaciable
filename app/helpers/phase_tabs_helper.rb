# frozen_string_literal: true
module PhaseTabsHelper
  include TabsHelper

  def phase_tabs(phase, current_tab)
    tabs = PHASE_TABS.call(phase)
    Tabs.new(phase, tabs, current_tab, self).all
  end

  PHASE_TABS = ->(_) { {} }
end
