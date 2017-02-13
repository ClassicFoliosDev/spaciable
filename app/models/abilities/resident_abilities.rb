# frozen_string_literal: true
module Abilities
  module ResidentAbilities
    def resident_abilities(resident)
      plot = resident.plot

      can :manage, Resident, id: resident.id

      resident_abilities_via_development(plot.development_id)
      resident_abilities_via_unit_type(plot.unit_type_id)
      resident_abilities_for_polymorphic_models(plot)
    end

    def resident_abilities_via_development(development_id)
      can :read, Developer, developments: { id: development_id }
      can :read, Division, developments: { id: development_id }
      can :read, Development, id: development_id
      can :read, Phase, development_id: development_id
      can :read, Plot, development_id: development_id
    end

    def resident_abilities_via_unit_type(unit_type_id)
      can :read, UnitType, id: unit_type_id
      can :read, Room, unit_type_id: unit_type_id
      can :read, Finish, room: { unit_type_id: unit_type_id }
      can :read, Appliance, rooms: { unit_type_id: unit_type_id }
    end

    def resident_abilities_for_polymorphic_models(plot)
      [Document, Faq, Contact, Notification].each do |model|
        can :read, model, development_id: plot.development_id
        can :read, model, developer_id: plot.developer_id
      end

      polymorphic_abilities Brand, :brandable do
        type "Developer", id: plot.developer_id, actions: :read
        type "Division", id: plot.division_id, actions: :read
        type "Development", id: plot.development_id, actions: :read
        type "Phase", id: plot.phase_id, actions: :read
      end
    end
  end
end
