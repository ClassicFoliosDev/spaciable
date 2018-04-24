class MigrateServicesText < ActiveRecord::Migration[5.0]
  def up
    puts "============"
    puts "Migrating services"

    other_service = Service.find_by(name: "Other Services")
    other_service&.update_attributes(description: "Security systems, smart home system providers, furniture packs, appliances, change of address service")
    puts "Updated text for Other Services"

    duplicate_maintenance_service = Service.find_by(name: "Maintenance providers")
    if duplicate_maintenance_service
      duplicate_maintenance_service.delete
      puts "Deleted duplicate maintenance service"
    end

    puts "==========="
  end

  def down
    # No reverse for these text content changes, to change the text again, migrate forward
  end
end
