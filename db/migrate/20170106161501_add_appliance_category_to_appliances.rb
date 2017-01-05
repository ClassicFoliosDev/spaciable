class AddApplianceCategoryToAppliances < ActiveRecord::Migration[5.0]
  def change
    add_reference :appliances, :appliance_category, foreign_key: true
    add_reference :appliances, :manufacturer, foreign_key: true
  end
end
