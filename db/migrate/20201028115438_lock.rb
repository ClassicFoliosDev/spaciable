class Lock < ActiveRecord::Migration[5.0]
  # lock
  def change
    reversible do |direction|

      direction.up {

        create_table :locks do |t|
          t.integer :job, null: false, index: { unique: true }
        end

      }

      direction.down {
        drop_table :locks
      }
    end
  end
end
