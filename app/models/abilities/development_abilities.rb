# frozen_string_literal: true
module Abilities
  module DevelopmentAbilities
    def development_abilities(development, division_id, developer_id)
      crud_user_permissions(role: :development_admin, id: development, model: "Development")

      development_notification_permissions(development)
      crud_development_permissions(development)
      read_development_permissions(developer_id, division_id, development)
    end

    private

    def crud_development_permissions(development)
      can :crud, Document, development_id: development
      can :crud, Finish, development_id: development
      can :crud, Image, development_id: development
      can :crud, Plot, development_id: development
    end

    def read_development_permissions(developer_id, division_id, development)
      can :read, Developer, id: developer_id
      can :read, Division, id: division_id
      can :read, Development, id: development
      can :read, Phase, development_id: development
      can :read, Room, development_id: development
      can :read, UnitType, development_id: development
    end

    def development_notification_permissions(development)
      manage_polymorphic_association(
        Notification, :send_to,
        id: development, model_type: "Development",
        actions: [:create, :read]
      )

      manage_polymorphic_association(
        Notification, :send_to,
        id: Phase.where(development_id: development).pluck(:id), model_type: "Phase",
        actions: [:create, :read]
      )
    end
  end
end
