class MigrateLegacyPlots < ActiveRecord::Migration[5.0]
  def up
    plots = Plot.includes(:address).where(addresses: {id: nil})

    if plots.any?
      puts "Migrating #{plots.count} plots which were missing addresses"
      puts "================"

      plots.each do |plot|
        plot.build_address
        plot.save
      end
    end
  end

  def down
    # No reverse for this migration.
  end
end
