class CreateApplianceManufacturers < ActiveRecord::Migration[5.0]
  def change
    create_table :appliance_manufacturers do |t|
      t.string :name
      t.datetime :deleted_at
      t.string :link

      t.timestamps
    end
  end
end
