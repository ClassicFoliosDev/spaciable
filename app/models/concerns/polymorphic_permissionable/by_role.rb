# frozen_string_literal: true
module PolymorphicPermissionable
  module ByRole
    extend ActiveSupport::Concern

    included do
      def assign_permissionable
        return if permissionable && blank_permission_ids?

        id_attr = permissionable_id_by_role
        type_attr = permissionable_type_by_role

        self.permissionable_id = send(id_attr) if id_attr
        self.permissionable_type = type_attr if type_attr
      end
    end
  end
end
