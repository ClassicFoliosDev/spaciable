class RemoveDevelopmentIdFromServices < ActiveRecord::Migration[5.0]
  def change
    remove_column :services, :development_id, :integer
  end
end
