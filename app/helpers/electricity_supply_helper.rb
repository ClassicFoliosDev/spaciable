# frozen_string_literal: true

module ElectricitySupplyHelper
  def electricity_supply_collection
    MaterialInfo.electricity_supplies.map do |(supply, _int)|
      [t(supply, scope: electricity_supply_label_scope), supply]
    end
  end

  private

  def electricity_supply_label_scope
    "activerecord.attributes.material_info.electricity_supply_labels"
  end
end
