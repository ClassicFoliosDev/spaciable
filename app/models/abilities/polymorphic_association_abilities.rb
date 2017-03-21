# frozen_string_literal: true
module Abilities
  module PolymorphicAssociationAbilities
    class PolymorphicAbility
      attr_reader :klass, :association, :ability
      def initialize(klass, association, ability)
        @klass = klass
        @association = association
        @ability = ability
        @actions = [:create, :read, :update, :destroy]
      end

      def actions(*actions)
        @actions = actions
        yield
      end

      def type(poly_type, id:, actions: @actions)
        ability.manage_polymorphic_association(
          klass, association, id: id, model_type: poly_type, actions: Array(actions)
        )
      end
    end

    def polymorphic_abilities(klass, association, &block)
      PolymorphicAbility.new(klass, association, self).instance_eval(&block)
    end

    def manage_polymorphic_association(klass, association, id:, model_type:, actions:)
      can(actions, klass, :"#{association}_id" => id, :"#{association}_type" => model_type)

      create_unassociated(actions)
    end

    private

    def create_unassociated(actions)
      return if !actions.include?(:create) || !actions.include?(:manage)

      can(:create, klass, :"#{association}_id" => nil, :"#{association}_type" => nil)
    end
  end
end
