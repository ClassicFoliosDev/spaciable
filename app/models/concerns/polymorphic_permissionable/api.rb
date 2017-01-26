# frozen_string_literal: true
module PolymorphicPermissionable
  module Api
    extend ActiveSupport::Concern

    InvalidPermissionableStrategy = Class.new(StandardError)
    STRATEGY_HINT = <<-MSG
      Include the assignment strategy by including either
      ```
      include PolymorphicPermissionable
      include PolymorphicPermissionable::ByRole
      ```
      or:
      ```
      include PolymorphicPermissionable
      include PolymorphicPermissionable::ByResources
      ```

      Using `::ByRole` to set the permissionable object to match the users role, e.g. if
      the users role is `development_admin` then the permissionable object will be set
      to the chosen `development`.

      Use `::ByResources` to set the permissionable object to the lowest denominator from
      the resource ids, e.g. if a `phase_id` exists then the permissionable object will
      be set to that phase.
    MSG

    class_methods do
      def permissionable_field(field)
        @permissionable_field = field
      end

      def permissionable_role(role_field)
        @permissionable_role = role_field
      end
    end

    included do
      def permissionable_id=(id)
        field = self.class.instance_variable_get("@permissionable_field")
        send("#{field}_id=", id)
      end

      def permissionable_id
        field = self.class.instance_variable_get("@permissionable_field")
        send("#{field}_id")
      end

      def permissionable_type=(type)
        field = self.class.instance_variable_get("@permissionable_field")
        send("#{field}_type=", type)
      end

      def permissionable_type
        field = self.class.instance_variable_get("@permissionable_field")
        send("#{field}_type")
      end

      def permissionable
        field = self.class.instance_variable_get("@permissionable_field")
        send(field)
      end

      def permissionable_role
        role = self.class.instance_variable_get("@permissionable_role") || :role
        send(role)
      end
    end
  end
end
