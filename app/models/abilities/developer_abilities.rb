# frozen_string_literal: true
module Abilities
  module DeveloperAbilities
    def developer_abilities(developer)
      crud_user_permissions(role: :developer_admin, id: developer, model: "Developer")
      can :crud, Document, developer_id: developer
      can :crud, Finish, developer_id: developer
      can :crud, Image, developer_id: developer
      can :crud, Plot, developer_id: developer
      can :read, Developer, id: developer
      can :read, Development, developer_id: developer
      can :read, Development, developer_id: developer
      can :read, Division, developer_id: developer
      can :read, Phase, developer_id: developer
      can :read, Room, developer_id: developer
      can :read, UnitType, developer_id: developer
    end
  end
end
