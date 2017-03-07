class AddUniquenessIndexes < ActiveRecord::Migration[5.0]
  def change
    add_index :developers, :company_name, unique: true, where: "deleted_at IS NULL"
    add_index :divisions, [:division_name, :developer_id], unique: :true, where: "deleted_at IS NULL"
    add_index :developments, [:name, :developer_id, :division_id], unique: true, where: "deleted_at IS NULL"
    add_index :phases, [:name, :development_id], unique: true, where: "deleted_at IS NULL"
    add_index :plots, [:prefix, :number, :development_id, :phase_id], unique: true, name: "plot_combinations", where: "deleted_at IS NULL"
    add_index :unit_types, [:name, :development_id], unique: true, where: "deleted_at IS NULL"
    add_index :rooms, [:name, :unit_type_id], unique: true, where: "deleted_at IS NULL"
    add_index :appliances, :name, unique: true, where: "deleted_at IS NULL"
    add_index :finishes, :name, unique: true, where: "deleted_at IS NULL"
  end
end
