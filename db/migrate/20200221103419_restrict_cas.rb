class RestrictCas < ActiveRecord::Migration[5.0]
  def change
    add_column :unit_types, :restricted, :boolean, default: false
  end
end
