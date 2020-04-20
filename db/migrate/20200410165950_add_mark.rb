class AddMark < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|

      direction.up {

        create_table :marks do |t|
          t.references :markable, polymorphic: true, index: true
          t.string :username
          t.integer :role
        end

        remove_column :rooms, :last_updated_by
        remove_column :finishes_rooms, :added_by
        remove_column :appliances_rooms, :added_by

        remove_column :logs, :username
        remove_column :logs, :role

        add_column :finishes_rooms, :id, :primary_key
        add_column :appliances_rooms, :id, :primary_key

      }

      direction.down {

        drop_table :marks

        remove_column :finishes_rooms, :id
        remove_column :appliances_rooms, :id

        add_column :rooms, :last_updated_by, :string, null: false, default: "CF Admin"
        add_column :finishes_rooms, :added_by, :string, null: false, default: "CF Admin"
        add_column :appliances_rooms, :added_by, :string, null: false, default: "CF Admin"

        add_column :logs, :username, :string
        add_column :logs, :role, :integer
      }
    end
  end
end
