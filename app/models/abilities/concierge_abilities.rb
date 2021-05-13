# frozen_string_literal: true

module Abilities
  module ConciergeAbilities
    def concierge_abilities(user)
      can :read, User, id: user.id
    end
  end
end
