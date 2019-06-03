class UpdateTablesForSnags < ActiveRecord::Migration[5.0]
  def change
    add_column :developments, :enable_snagging, :boolean, default: false
    add_column :developments, :snag_duration, :integer, default: 0
    add_column :developments, :snag_name, :string, null: false, default: "Snagging"

    add_column :users, :snag_notifications, :boolean, default: true

    add_column :plots, :total_snags, :integer, default: 0
    add_column :plots, :unresolved_snags, :integer, default: 0

    add_column :phases, :total_snags, :integer, default: 0
    add_column :phases, :unresolved_snags, :integer, default: 0
  end
end
