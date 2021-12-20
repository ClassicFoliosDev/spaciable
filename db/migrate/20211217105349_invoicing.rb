class Invoicing < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|

      direction.up {
        create_table :invoices do |t|
          t.references :phase, index: true
          t.integer :package
          t.integer :plots
          t.timestamps null: false
        end
      }

      direction.down {
        drop_table :invoices
      }
    end
  end
end
