class MigrateExistingInvitedBy < ActiveRecord::Migration[5.0]
  def up
    puts "================="
    puts "Migrating the resident invited by onto the plot residencies"
    puts "-----------------"

    changed_count = 0

    Resident.all.each do |resident|
      resident.plots.each do |plot|
        residency = PlotResidency.find_by(plot_id: plot.id, resident_id: resident.id)
        changed_count += 1
        residency.update_attributes(invited_by_type: resident.invited_by_type, invited_by_id: resident.invited_by_id)
      end
    end

    puts "----------------"
    puts "Migrated #{changed_count} plot_residencies"
    puts "================"
  end

  def down
    # No reverse for this migration.
    # If you reverse the previous migration, which adds the invited_by columns to plot_residency, that will undo these changes as a side-effect
  end
end
