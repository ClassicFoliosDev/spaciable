class MigrateServices < ActiveRecord::Migration[5.0]
  def up
    Service.categories.each do |category|
      Service.find_or_create_by(category: category.last.to_i)
    end
  end

  # Uncomment if you really want to destroy the services
  # WARNING: This will also destroy all dependent service_residents, and is not recommended
  def down
    Service.categories.each do |category|
      service.really_destroy!
    end
  end
end
