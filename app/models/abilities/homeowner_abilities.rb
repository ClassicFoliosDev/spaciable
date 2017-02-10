# frozen_string_literal: true
module Abilities
  module HomeownerAbilities
    def homeowner_abilities(resident)
      development_ids = resident.developments.pluck(:id)

      can :read, Developer, developments: { id: development_ids }
      can :read, Development, id: development_ids
      can :read, Division, developer: { developments: { id: development_ids } }
      can :read, Document, development_id: development_ids
      can :read, Finish, development_id: development_ids
      can :read, Image, development_id: development_ids
      can :read, Phase, development_id: development_ids
      can :read, Plot, development_id: development_ids
      can :read, Room, development_id: development_ids
      can :read, UnitType, development_id: development_ids

      can :manage, User, id: user.id
    end
  end
end
