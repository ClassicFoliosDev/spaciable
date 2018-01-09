class AddDevelopmentMessagesToDeveloper < ActiveRecord::Migration[5.0]
  def change
    add_column :developers, :enable_development_messages, :boolean, default: false
  end
end
