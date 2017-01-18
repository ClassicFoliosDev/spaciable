# frozen_string_literal: true
module Admin
  module UsersHelper
    def admin_users_developer_select_options
      Developer.accessible_by(current_ability).order(:company_name).map do |developer|
        [developer.to_s, developer.id]
      end
    end

    def admin_users_division_select_options
      Division.accessible_by(current_ability).order(:division_name).map do |division|
        data = { developer: division.developer_id }
        [division.to_s, division.id, { data: data }]
      end
    end

    def admin_users_development_select_options
      relation = Development.includes(:division).accessible_by(current_ability).order(:name)

      relation.map do |development|
        division = development.division
        data = {
          developer: development.developer_id || division&.developer_id,
          division: development.division_id
        }

        [development.to_s, development.id, { data: data }]
      end
    end
  end
end
