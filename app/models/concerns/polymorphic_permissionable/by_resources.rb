# frozen_string_literal: true
module PolymorphicPermissionable
  module ByResources
    extend ActiveSupport::Concern

    included do
      def assign_permissionable
        return if permissionable && blank_permission_ids?

        resource_id, resource_type = first_id_and_type_present

        self.permissionable_id = resource_id
        self.permissionable_type = resource_type
      end

      def first_id_and_type_present
        if phase_id.present?
          [phase_id, "Phase"]
        elsif development_id.present?
          [development_id, "Development"]
        elsif division_id.present?
          [division_id, "Division"]
        elsif developer_id.present?
          [developer_id, "Developer"]
        end
      end
    end
  end
end
