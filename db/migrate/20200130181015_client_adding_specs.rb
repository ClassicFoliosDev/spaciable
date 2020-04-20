class ClientAddingSpecs < ActiveRecord::Migration[5.0]

  def change
    # Clients-Adding-Specsenablements
    add_column :developers, :cas, :boolean, default: false
    add_column :developments, :cas, :boolean, default: false
    add_column :users, :cas, :boolean, default: false

    # Add foreign keys to CAS relevant tables
    add_column :finishes, :developer_id, :integer
    add_foreign_key :finishes, :developers
    add_column :finish_manufacturers, :developer_id, :integer
    add_foreign_key :finish_manufacturers, :developers
    add_column :finish_types, :developer_id, :integer
    add_foreign_key :finish_types, :developers
    add_column :finish_categories, :developer_id, :integer
    add_foreign_key :finish_categories, :developers
    add_column :appliances, :developer_id, :integer
    add_foreign_key :appliances, :developers
    add_column :appliance_categories, :developer_id, :integer
    add_foreign_key :appliance_categories, :developers
    add_column :appliance_manufacturers, :developer_id, :integer
    add_foreign_key :appliance_manufacturers, :developers

    # last_updated_by tracking for rooms - default to cf_admin
    add_column :rooms, :last_updated_by, :string, null: false, default: "CF Admin"
    add_column :finishes_rooms, :added_by, :string, null: false, default: "CF Admin"
    add_column :appliances_rooms, :added_by, :string, null: false, default: "CF Admin"

    # indexes for Finish searches
    add_index :finish_manufacturers, 'lower(name) varchar_pattern_ops', name: "search_index_on_finish_manufacturer_name"
    add_index :finish_types, 'lower(name) varchar_pattern_ops', name: "search_index_on_finish_type_name"

    reversible do |direction|
      direction.up {
        # destroy (paranoid) deleted Appliances and Finishes
        Appliance.deleted.each { |a| a.really_destroy! }
        Finish.deleted.each { |f| f.really_destroy! }

        # set the default cas enablements for the existing users
        User.where(role: ['cf_admin', 'developer_admin','division_admin']).each { |u| u.update_attribute(:cas, true) }
        User.where(role: ['development_admin','site_admin']).each { |u| u.update_attribute(:cas, false) }

        # Change index on finishes
        remove_index :finishes, :name => 'index_finishes_on_name'
        add_index :finishes, [:name, :finish_category_id, :finish_type_id, :finish_manufacturer_id, :developer_id], unique: true, :name => 'index_finishes_on_combo'

        # delete and rebuild finish search indexes
        PgSearch::Document.delete_all(:searchable_type => "Finish")
        Finish.find_each { |finish| finish.update_pg_search_document }
      }

      direction.down {
        # reinstate Finishes index
        remove_index :finishes, :name => 'index_finishes_on_combo'
        add_index :finishes, [:name], unique: true, :name => 'index_finishes_on_name'

        # delete and rebuild finish search indexes
        PgSearch::Document.delete_all(:searchable_type => "Finish")
        Finish.find_each { |finish| finish.update_pg_search_document }
      }
    end
  end

end
