# frozen_string_literal: true
module Abilities
  module CfAdminAbilities
    def cf_admin_abilities
      can :manage, :all

      cannot :create, PlotResidency do |residency|
        residency.plot.reload.resident.present?
      end
    end
  end
end
