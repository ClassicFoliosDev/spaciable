class AddServicesToDevelopers < ActiveRecord::Migration[5.0]
  def change
    add_column :developers, :enable_services, :boolean, default: :false
  end
end
