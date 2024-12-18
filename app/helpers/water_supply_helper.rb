# frozen_string_literal: true

module WaterSupplyHelper
  def water_supply_collection
    MaterialInfo.water_supplies.map do |(supply, _int)|
      [t_water_supply(supply), supply]
    end
  end

  def t_water_supply(supply)
    t(supply, scope: water_supply_label_scope)
  end

  private

  def water_supply_label_scope
    "activerecord.attributes.material_info.water_supply_labels"
  end
end
