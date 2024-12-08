class MaterialInfo < ActiveRecord::Migration[5.2]
  def change

    create_table :heating_fuels do |t|
      t.string :name
    end

    create_table :heating_sources do |t|
      t.string :name
    end

    create_table :heating_outputs do |t|
      t.string :name
    end

    create_table :material_infos do |t|
      t.references :plot
      t.integer :selling_price, default: 0
      t.integer :reservation_fee, default: 0
      t.integer :tenure, default: 0 #MaterialInfo.tenures[:unassigned]
      t.integer :lease_length, default: 0
      t.integer :service_charges, default: 0
      t.integer :council_tax_band, default: 0 #MaterialInfo.council_tax_bands[:unavailable]
      t.integer :property_type, default: 0 #MaterialInfo.property_types[:detached]
      t.integer :floor, default: 0 #MaterialInfo.floors[:ground]
      t.integer :floorspace, default: 0
      t.datetime :estimated_legal_completion_date, default: nil
      t.integer :epc_rating, default: 0 #MaterialInfo.epc_ratings[:no_rating]
      t.integer :plot_construction, default: 0 #MaterialInfo.plot_constructions[:traditional]
      t.string :plot_construction_other, default: nil
      t.integer :electricty_supply, default: 0 #MaterialInfo.electricity_supplies[:mains_electricity]
      t.string :electricty_supply_other, default: nil
      t.integer :water_supply, default: 0 #MaterialInfo.water_supplies[:mains_water]
      t.integer :sewerage, default: 0 #MaterialInfo.sewerages[:mains_sewerage]
      t.string :sewerage_other, default: nil
      t.integer :broadband, default: 0 #MaterialInfo.broadbands[:not_applicable]
      t.integer :mobile_signal, default: 0 #MaterialInfo.mobile_signals[:good]
      t.string :mobile_signal_restrictions, default: nil
      t.integer :parking, default: 0 #MaterialInfo.parkings[:no_parking]
      t.string :building_safety, default: nil
      t.string :restrictions, default: nil
      t.string :rights_and_easements, default: nil
      t.string :flood_risk, default: nil
      t.string :planning_permission_or_proposals, default: nil
      t.string :accessibility, default: nil
      t.string :coalfield_or_mining_areas, default: nil
      t.string :other_considerations, default: nil
      t.string :warranty_num
      t.integer :mprn 
      t.integer :mpan
    end

    create_table :heating_fuels_material_infos do |t|
      t.references :heating_fuel
      t.references :material_info
    end

    create_table :heating_sources_material_infos do |t|
      t.references :heating_source
      t.references :material_info
    end

    create_table :heating_outputs_material_infos do |t|
      t.references :heating_output
      t.references :material_info
    end

    add_reference :plots, :material_info, foreign_key: true
    
    Rake::Task['material_info:migrate'].invoke
  end
end
