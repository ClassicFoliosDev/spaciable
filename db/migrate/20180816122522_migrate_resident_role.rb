class MigrateResidentRole < ActiveRecord::Migration[5.0]
  def up
    puts "================="
    puts "Migrating the resident role onto the plot residency role"
    puts "-----------------"

    changed_count = 0

    Resident.all.each do |resident|
      plot_residency_role = if resident.plots.count > 1
        # If the resident has more than one plot, assume the resident is a landlord / homeowner
        PlotResidency.roles[:homeowner]
      elsif resident.invited_by_type == "User"
        PlotResidency.roles[:homeowner]
      elsif resident.invited_by_type == "Resident"
        PlotResidency.roles[:tenant]
      else
        puts "WARNING #{resident.email} #{resident.to_s} has no invited by, setting to landlord/ homeowner"
        PlotResidency.roles[:homeowner]
      end

      resident.plots.each do |plot|
        residency = PlotResidency.find_by(plot_id: plot.id, resident_id: resident.id)
        # Don't overwrite existing plot residency entries
        next unless residency.role.blank?

        changed_count += 1
        residency.update_attributes(role: plot_residency_role)
      end
    end

    puts "----------------"
    puts "Migrated #{changed_count} plot_residencies"
    puts "================"
  end

  def down
    # No reverse for this migration.
    # If you reverse the previous migration, which adds the role column to plot_residency, that will undo these changes as a side-effect
  end
end
