# frozen_string_literal: true

module InheritPolymorphicParentPermissionIds
  extend ActiveSupport::Concern

  included do
    def set_permissable_ids
      return unless parent

      set_permissable_ids_for_parent_associations
      set_permissable_ids_for_parent_type
    end

    def set_permissable_ids_for_parent_type
      case parent
      when Development
        self.development_id = parent.id
      when Division
        self.division_id = parent.id
      when Developer
        self.developer_id = parent.id
      end
    end
  end
end
