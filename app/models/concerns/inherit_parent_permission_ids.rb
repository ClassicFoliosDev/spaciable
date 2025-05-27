# frozen_string_literal: true

module InheritParentPermissionIds
  extend ActiveSupport::Concern

  ParentUndefined = Class.new(StandardError)
  undefined_parent_hint = <<-HINT
    For auto inheriting of the required ids for permissions, developer_id or division_id,
    define a parent association where these can be inherited from.

    For example:

    ```
    belongs_to :development
    alias parent development
    include #{name}
    ````
  HINT

  included do
    raise ParentUndefined, undefined_parent_hint unless new.respond_to?(:parent)

    before_validation :set_permissable_ids
    validate :permissable_id_presence

    def permissable_id_presence
      return unless developer_id.blank? && division_id.blank?

      errors.add(:base, :missing_permissable_id)
    end

    def set_permissable_ids
      return unless parent

      set_permissable_ids_for_parent_associations
    end

    def set_permissable_ids_for_parent_associations
      self.development_id = parent.development_id if parent.respond_to?(:development_id)
      self.division_id = parent.division_id if parent.respond_to?(:division_id)
      self.developer_id = parent.developer_id if parent.respond_to?(:developer_id)

      set_developer_if_division unless developer_id
    end

    def set_developer_if_division
      return unless division

      self.developer_id = division.developer_id
    end
  end
end
