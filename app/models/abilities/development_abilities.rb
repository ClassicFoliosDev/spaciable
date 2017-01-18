# frozen_string_literal: true
module Abilities
  module DevelopmentAbilities
    def development_abilities(development, division_id, developer_id)
      crud_user_permissions(role: :development_admin, id: development, model: "Development")
      can :crud, Document, development_id: development
      can :crud, Finish, development_id: development
      can :crud, Image, development_id: development
      can :crud, Plot, development_id: development
      can :read, Developer, id: developer_id
      can :read, Division, id: division_id
      can :read, Development, id: development
      can :read, Phase, development_id: development
      can :read, Room, development_id: development
      can :read, UnitType, development_id: development
    end
  end
end
