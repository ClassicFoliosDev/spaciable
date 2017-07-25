# frozen_string_literal: true
module Abilities
  module CfAdminAbilities
    def cf_admin_abilities
      can :manage, :all
    end
  end
end
