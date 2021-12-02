class StripeCodes < ActiveRecord::Migration[5.0]
 def change
    reversible do |direction|

      direction.up {
         add_column :developers, :on_package, :boolean, default: false
         add_column :developers, :stripe_code, :string, default: nil

        create_table :stripe_codes do |t|
          t.references :developer
          t.integer :package
          t.string :code
        end
      }

      direction.down {
        remove_column :developers, :on_package
        remove_column :developers, :stripe_code
        drop_table :stripe_codes
      }
    end
  end
end

