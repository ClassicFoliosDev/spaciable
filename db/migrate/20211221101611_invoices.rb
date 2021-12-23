class Invoices < ActiveRecord::Migration[5.0]
 def change
    reversible do |direction|

      direction.up {
        Rake::Task['cas_package:initialise'].invoke

        create_table :invoices do |t|
          t.references :phase, index: true
          t.integer :package
          t.integer :plots
          t.timestamps null: false
        end

        remove_column :finish_types, :developer_id
        remove_column :finish_categories, :developer_id
        remove_column :appliance_categories, :developer_id
        remove_column :appliance_manufacturers, :developer_id
      }

      direction.down {
        drop_table :invoices

        add_column :finish_types, :developer_id, :integer
        add_column :finish_categories, :developer_id, :integer
        add_column :appliance_categories, :developer_id, :integer
        add_column :appliance_manufacturers, :developer_id, :integer
      }
    end
  end
end
