class RegisterAppliance < ActiveRecord::Migration[5.2]
  def change
    add_column :appliance_categories, :register, :boolean, default: true
  end
end
