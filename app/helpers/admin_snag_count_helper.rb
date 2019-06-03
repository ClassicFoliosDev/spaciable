# frozen_string_literal: true

module AdminSnagCountHelper
  def user_unresolved_snag_count(current_user)
    @unresolved_snag_count = 0
    get_phases(current_user)
    unresolved_snag_count
  end

  def get_phases(_current_user)
    @phases = Phase.accessible_by(current_ability)
  end

  def unresolved_snag_count
    @phases.each do |phase|
      @unresolved_snag_count += phase.unresolved_snags
    end
    @unresolved_snag_count
  end
end
