class UnassignedMaterialInfo < ActiveRecord::Migration[5.2]
  def change
   reversible do |direction|
      direction.up {

        MaterialInfo.where(infoable_type: "Plot").all.each do |mi|
          mi.property_construction = mi.property_construction_before_type_cast + 1
          mi.electricity_supply = mi.electricity_supply_before_type_cast + 1
          mi.water_supply = mi.water_supply_before_type_cast + 1
          mi.sewerage = mi.sewerage_before_type_cast + 1
          mi.broadband = mi.broadband_before_type_cast + 1
          mi.mobile_signal = mi.mobile_signal_before_type_cast + 1
          mi.parking = mi.parking_before_type_cast + 1
          mi.save
        end
      }

      direction.down {
        MaterialInfo.where(infoable_type: "Plot").all.each do |mi|
          mi.property_construction = mi.property_construction_before_type_cast - 1
          mi.electricity_supply = mi.electricity_supply_before_type_cast - 1
          mi.water_supply = mi.water_supply_before_type_cast - 1
          mi.sewerage = mi.sewerage_before_type_cast - 1
          mi.broadband = mi.broadband_before_type_cast - 1
          mi.mobile_signal = mi.mobile_signal_before_type_cast - 1
          mi.parking = mi.parking_before_type_cast - 1
          mi.save
        end
      }
    end
  end
end
