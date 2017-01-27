# frozen_string_literal: true
module Abilities
  module DeveloperAbilities
    include PolymorphicAssociationAbilities

    def developer_abilities(developer)
      crud_user_permissions(role: :developer_admin, id: developer, model: "Developer")

      developer_notification_permissions(developer)
      crud_developer_permissions(developer)
      read_developer_permissions(developer)
    end

    private

    def developer_notification_permissions(developer_id)
      manage_polymorphic_association(
        Notification, :send_to,
        id: developer_id, model_type: "Developer",
        actions: [:manage]
      )
      cannot :manage, Notification, send_to_all: true
    end

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
