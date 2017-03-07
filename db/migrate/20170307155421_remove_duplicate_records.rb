class RemoveDuplicateRecords < ActiveRecord::Migration[5.0]
  def up
    ####################################################################################
    # Remove all records that invalidate uniqueness before creating the unique indexes #
    ####################################################################################

    # Remove old association that breaks deleting a room
    remove_column :finishes, :room_id

    Room.find_each do |room|
      room.validate

      if room.errors.details[:name].include?({ error: :taken, value: room.name })
        room.really_destroy!
      end
    end

    Appliance.find_each do |appliance|
      appliance.validate

      if appliance.errors.details[:name].include?({ error: :taken, value: appliance.name })
        appliance.really_destroy!
      end
    end

    Finish.find_each do |finish|
      finish.validate

      if finish.errors.details[:name].include?({ error: :taken, value: finish.name })
        finish.really_destroy!
      end
    end

    Plot.find_each do |plot|
      plot.validate

      if plot.errors.details[:base].include?({ error: :combination_taken })
        plot.really_destroy!
      elsif plot.errors.details[:base].include?({ error: :number_taken, value: plot.number.to_s })
        plot.really_destroy!
      end
    end

    Phase.find_each do |phase|
      phase.validate

      if phase.errors.details[:name].include?({ error: :taken, value: phase.name })
        phase.really_destroy!
      end
    end

    UnitType.find_each do |unit_type|
      unit_type.validate

      if unit_type.errors.details[:name].include?({ error: :taken, value: unit_type.name })
        unit_type.really_destroy!
      end
    end

    Development.find_each do |development|
      development.validate

      if development.errors.details[:name].include?({ error: :taken, value: development.name })
        development.really_destroy!
      end
    end

    Division.find_each do |division|
      division.validate

      if division.errors.details[:division_name].include?({ error: :taken, value: division.division_name })
        division.really_destroy!
      end
    end

    Developer.find_each do |developer|
      developer.validate

      if developer.errors.details[:company_name].include?({ error: :taken, value: developer.company_name })
        developer.really_destroy!
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
