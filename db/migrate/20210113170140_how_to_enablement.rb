class HowToEnablement < ActiveRecord::Migration[5.0]
  def change
    add_column :developers, :enable_how_tos, :boolean, default: true
  end
end
