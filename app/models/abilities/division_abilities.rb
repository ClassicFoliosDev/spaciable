# frozen_string_literal: true
module Abilities
  module DivisionAbilities
    def division_abilities(division, developer_id)
      crud_user_permissions(role: :division_admin, id: division, model: "Division")

      division_notification_permissions(division)
      crud_division_permissions(division)
      read_division_permissions(developer_id, division)
    end

    private

    def crud_division_permissions(division)
      can :crud, Document, division_id: division
      can :crud, Finish, division_id: division
      can :crud, Image, division_id: division
      can :crud, Plot, division_id: division
    end

    def read_division_permissions(developer_id, division)
      can :read, Developer, id: developer_id
      can :read, Development, division_id: division
      can :read, Division, id: division
      can :read, Phase, division_id: division
      can :read, Room, division_id: division
      can :read, UnitType, division_id: division
    end

    def division_notification_permissions(division)
      manage_polymorphic_association(
        Notification, :send_to,
        id: division, model_type: "Division",
        actions: [:create, :read]
      )
    end
  end
end
