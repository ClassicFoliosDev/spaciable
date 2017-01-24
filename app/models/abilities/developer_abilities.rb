# frozen_string_literal: true
module Abilities
  module DeveloperAbilities
    include PolymorphicAssociationAbilities

    def developer_abilities(developer)
      model = "Developer"

      crud_user_permissions(role: :developer_admin, id: developer, model: model)

      manage_polymorphic_association(
        Notification, :send_to,
        id: developer, model_type: model,
        actions: [:create, :read]
      )

      crud_developer_permissions(developer)
      read_developer_permissions(developer)
    end

    private

    def crud_developer_permissions(developer_id)
      can :crud, Document, developer_id: developer_id
      can :crud, Finish, developer_id: developer_id
      can :crud, Image, developer_id: developer_id
      can :crud, Plot, developer_id: developer_id
    end

    def read_developer_permissions(developer_id)
      can :read, Developer, id: developer_id
      can :read, Development, developer_id: developer_id
      can :read, Development, developer_id: developer_id
      can :read, Division, developer_id: developer_id
      can :read, Phase, developer_id: developer_id
      can :read, Room, developer_id: developer_id
      can :read, UnitType, developer_id: developer_id
    end
  end
end
