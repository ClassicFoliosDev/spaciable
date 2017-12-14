class MigrateCompletionDateData < ActiveRecord::Migration[5.0]
  def up
    plot_residencies_with_dates = PlotResidency.where.not(completion_date: nil)

    plot_residencies_with_dates.each do | plot_residency |
      plot = Plot.find(plot_residency.plot_id)

      if plot&.completion_date != plot_residency.completion_date
        resident = plot_residency.resident
        message = "WARNING: Different completion date, plot: #{plot.id}. "
        message << "Plot completion date: #{plot.completion_date}. "
        message << "Resident is #{resident.email}, completion date: #{plot_residency.completion_date}"
        say_with_time(message) do
          # Do nothing inside the say block, we just want to report the problem
        end
      else
        plot.update_attribute(:completion_date, plot_residency.completion_date)
      end
    end
  end

  def down
    # No reverse for this data migration, it copies values into plot completion_date column
    # If you want to remove both contents and the completion_date column from the plots table
    # run rollback on migration 20171214110542_add_completion_date_to_plot
  end
end
