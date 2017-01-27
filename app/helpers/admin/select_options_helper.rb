# frozen_string_literal: true
module Admin
  module SelectOptionsHelper
    def admin_developer_select_options
      Developer
        .accessible_by(current_ability)
        .order(:company_name)
        .map { |developer| [developer.to_s, developer.id] }
    end

    def admin_division_select_options(division_id)
      return [] if !division_id && current_user.cf_admin?

      Division
        .accessible_by(current_ability)
        .order(:division_name)
        .map { |division| [division.to_s, division.id] }
    end

    def admin_development_select_options(development_id)
      return [] if !development_id && current_user.cf_admin?

      Development
        .accessible_by(current_ability)
        .order(:name)
        .map { |development| [development.to_s, development.id] }
    end

    def admin_phase_select_options(phase_id)
      return [] if !phase_id && current_user.cf_admin?

      Phase
        .accessible_by(current_ability)
        .order(:name)
        .map { |phase| [phase.to_s, phase.id] }
    end
  end
end
