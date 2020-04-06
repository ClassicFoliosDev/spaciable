# frozen_string_literal: true

module Abilities
  module CfAdminAbilities
    def cf_admin_abilities
      can :manage, :all

      can %i[production bulk_edit release_plots], Phase
      can %i[development_csv], Development
      cannot :cas_update, :all

      restricted(Appliance,
                 ApplianceCategory,
                 ApplianceManufacturer,
                 Finish,
                 FinishType,
                 FinishCategory,
                 FinishManufacturer)
    end

    private

    # Cannot read/update/destroy these classes when the developer_id is not NULL.
    def restricted(*klasses)
      klasses.each do |klass|
        cannot %i[read update destroy], klass,
               ["#{klass.table_name}.developer_id IS NOT ?", nil] do |k|
          k.developer_id.present?
        end
      end
    end
  end
end
