class ChangeDefaultValidity < ActiveRecord::Migration[5.0]
  def up
    change_column_default(:plots, :validity, 27)

    updated_count = 0
    Plot.all.each do |plot|
      if plot.validity == 24
        plot.update_attributes(validity: 27)
        updated_count += 1
      end
    end
    puts "========"
    puts "MIGRATED #{updated_count} plots, changed validity from 24 to 27"
    puts "========"
  end

  def down
    change_column_default(:plots, :validity, 24)

    Plot.all.each do |plot|
      plot.update_attributes(validity: 24) if plot.validity == 27
    end
  end
end
