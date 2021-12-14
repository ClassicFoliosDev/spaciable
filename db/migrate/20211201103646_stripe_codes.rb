class StripeCodes < ActiveRecord::Migration[5.0]
 def change
    reversible do |direction|

      direction.up {
        add_column :developers, :on_package, :boolean, default: false

        create_table :customers do |t|
          t.references :customerable, polymorphic: true, index: false
          t.string :code
        end

        create_table :package_prices do |t|
          t.references :customer
          t.integer :package
          t.string :code
        end
      }

      direction.down {
        remove_column :developers, :on_package
        drop_table :customers
        drop_table :package_prices
      }
    end
  end
end

