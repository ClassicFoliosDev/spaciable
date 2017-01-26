# frozen_string_literal: true
module Admin
  module SelectOptionsHelper
    def admin_developer_select_options(resource, developer_id: nil)
      resource.assign_permissionable_ids
      return [] if !developer_id && !resource.developer_id

      developer = Developer
                  .accessible_by(current_ability)
                  .find_by(id: resource.developer_id || developer_id)

      developer ? [[developer.to_s, developer.id]] : []
    end

    def admin_division_select_options(resource)
      resource.assign_permissionable_ids
      return [] unless resource.division_id

      division = Division
                 .accessible_by(current_ability)
                 .find_by(id: resource.division_id)

      division ? [[division.to_s, division.id]] : []
    end

    def admin_development_select_options(resource)
      resource.assign_permissionable_ids
      return [] if !resource.developer_id || !resource.division_id

      developments = Development.includes(:division).accessible_by(current_ability)

      if resource.division_id
        developments.where(division_id: resource.division_id)
      elsif resource.developer_id
        developments.by_developer_and_developer_divisions(resource.developer_id)
      end.map { |development| [development.to_s, development.id] }
    end

    def admin_phase_select_options(resource)
      resource.assign_permissionable_ids
      return [] unless resource.development_id

      Phase
        .includes(:development)
        .accessible_by(current_ability)
        .where(development_id: resource.development_id)
        .map { |phase| [phase.to_s, phase.id] }
    end
  end
end
