# frozen_string_literal: true
module Abilities
  module PolymorphicAssociationAbilities
    def manage_polymorphic_association(klass, association, id:, model_type:, actions: default)
      can :create, klass if actions.delete(:create)
      can(
        actions,
        klass,
        :"#{association}_id" => id,
        :"#{association}_type" => model_type
      )
    end

    private

    def default
      [:create, :read, :update, :destroy]
    end
  end
end
