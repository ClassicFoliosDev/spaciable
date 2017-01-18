# frozen_string_literal: true
module Abilities
  module UserPermissions
    def crud_user_permissions(role:, id:, model:)
      user_role = User.roles[role]

      can :create, User, role: user_role
      can(
        [:read, :update, :destroy],
        User,
        role: user_role,
        permission_level_id: id,
        permission_level_type: model
      )
    end
  end
end
