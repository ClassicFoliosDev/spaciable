# frozen_string_literal: true

module ElectricitySupplyHelper
  def electricity_supply_collection
    MaterialInfo.electricity_supplies.map do |(supply, _int)|
      [t_electricity_supply(supply), supply]
    end
  end

  def t_electricity_supply(supply)
    t(supply, scope: electricity_supply_label_scope)
  end

  private

  def electricity_supply_label_scope
    "activerecord.attributes.material_info.electricity_supply_labels"
  end
end
