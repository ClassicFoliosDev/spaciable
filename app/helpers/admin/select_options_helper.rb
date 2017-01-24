# frozen_string_literal: true
module Admin
  module SelectOptionsHelper
    def admin_developer_select_options(resource, developer_id: nil)
      resource.populate_permission_ids
      return [] if !developer_id && !resource.developer_id

      developer = Developer
                  .accessible_by(current_ability)
                  .find_by(id: developer_id || resource.developer_id)

      developer ? [[developer.to_s, developer.id]] : []
    end

    def admin_division_select_options(resource)
      resource.populate_permission_ids
      return [] unless resource.division_id

      division = Division
                 .accessible_by(current_ability)
                 .find_by(id: resource.division_id)

      division ? [[division.to_s, division.id]] : []
    end

    def admin_development_select_options(resource)
      resource.populate_permission_ids
      return [] unless resource.development_id

      development = Development
                    .includes(:division)
                    .accessible_by(current_ability)
                    .find_by(id: resource.development_id)

      development ? [[development.to_s, development.id]] : []
    end

    def admin_phase_select_options(resource)
      resource.populate_permission_ids
      return [] unless resource.phase_id

      phase = Phase
              .includes(:development)
              .accessible_by(current_ability)
              .find_by(id: resource.phase_id)
      phase ? [[phase.to_s, phase.id]] : []
    end
  end
end
