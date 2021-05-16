class Tour < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|

      direction.up {

        create_table :tour_steps do |t|
          t.integer :sequence
          t.string :selector
          t.string :intro
          t.integer :position
        end

        Rake::Task['tour:initialise'].invoke
      }

      direction.down {
        drop_table :tour_steps
      }

    end
  end
end
