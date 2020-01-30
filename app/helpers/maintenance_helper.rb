# frozen_string_literal: true

module MaintenanceHelper
  def maintenance_account_types_collection
    Maintenance.account_types.map do |(account_type_name, _account_type_int)|
      [t(account_type_name, scope: account_types_scope), account_type_name]
    end
  end

  private

  def account_types_scope
    "activerecord.attributes.maintenance.account_types"
  end
end
