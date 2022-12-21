class SpotlightSequences < ActiveRecord::Migration[5.0]
  def change
	reversible do |direction|
	  direction.up {	  	
	  	add_column :spotlights, :sequence_no, :integer

	  	index = 0
	  	Spotlight.all.each {|s| s.update_column(:sequence_no, index += 1) }
	  	Rake::Task["spotlight_seq:initialise"].invoke(" #{index+1}")
        execute "ALTER TABLE spotlights ALTER COLUMN sequence_no SET DEFAULT NEXTVAL('spotlight_seq');"
	  }

	  direction.down {
	  	remove_column :spotlights, :sequence_no
	  	execute 'DROP SEQUENCE IF EXISTS spotlight_seq;'
      }
    end
  end
end
