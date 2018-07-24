# frozen_string_literal: true

module PolymorphicPermissionable
  extend ActiveSupport::Concern
  extend Api
  include Api

  # rubocop:disable BlockLength
  included do
    attr_accessor :developer_id, :division_id, :development_id, :phase_id, :plot_id

    before_validation :assign_permissionable
    before_validation :assign_permissionable_ids

    validate :permissionable_ids_selected

    def assign_permissionable
      raise Api::InvalidPermissionableStrategy, Api::STRATEGY_HINT
    end

    def permissionable_ids_selected
      id_attr = permissionable_id_by_role
      return unless id_attr
      errors.add(id_attr, :select) if send(id_attr).blank?
    end

    def assign_permissionable_ids
      return unless permissionable

      case permissionable
      when Developer
        set_developer_id
      when Division
        set_division_id
      when Development
        set_development_id
      when Phase
        set_phase_id
      when Plot
        set_plot_id
      end
    end

    private

    def permissionable_id_by_role
      return unless permissionable_role

      case permissionable_role.to_sym
      when :site_admin then :development_id
      when :development_admin then :development_id
      when :division_admin then :division_id
      when :developer_admin then :developer_id
      end
    end

    def permissionable_type_by_role
      return unless permissionable_role

      case permissionable_role.to_sym
      when :site_admin then "Development"
      when :development_admin then "Development"
      when :division_admin then "Division"
      when :developer_admin then "Developer"
      end
    end

    def blank_permission_ids?
      [developer_id, division_id, development_id, phase_id].all?(&:blank?)
    end

    def set_developer_id
      self.developer_id = permissionable_id
    end

    def set_division_id
      self.division_id = permissionable_id
      self.developer_id = permissionable.developer_id
    end

    def set_development_id
      self.development_id = permissionable.id
      self.division_id = permissionable.division_id
      self.developer_id = permissionable.developer_id ||
                          permissionable.division&.developer_id
    end

    def set_phase_id
      self.phase_id = permissionable.id
      self.development_id = permissionable.development_id
      self.division_id = permissionable.division_id
      self.developer_id = permissionable.developer_id ||
                          permissionable.division&.developer_id
    end

    def set_plot_id
      self.plot_id = permissionable.id
      self.phase_id = permissionable.phase_id
      self.development_id = permissionable.development_id
      self.division_id = permissionable.division_id
      self.developer_id = permissionable.developer_id ||
                          permissionable.division&.developer_id
    end
  end
  # rubocop:enable BlockLength
end
