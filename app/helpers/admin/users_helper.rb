# frozen_string_literal: true
module Admin
  module UsersHelper
    def admin_users_developer_select_options(user)
      user.assign_permissionable_ids
      return [] unless user.developer_id

      developer = Developer
                  .accessible_by(current_ability)
                  .find_by(id: user.developer_id)

      developer ? [[developer.to_s, developer.id]] : []
    end

    def admin_users_division_select_options(user)
      user.assign_permissionable_ids
      return [] unless user.division_id

      division = Division
                 .accessible_by(current_ability)
                 .find_by(id: user.division_id)

      division ? [[division.to_s, division.id]] : []
    end

    def admin_users_development_select_options(user)
      user.assign_permissionable_ids
      return [] unless user.development_id

      development = Development
                    .includes(:division)
                    .accessible_by(current_ability)
                    .find_by(id: user.development_id)

      development ? [[development.to_s, development.id]] : []
    end
  end
end
