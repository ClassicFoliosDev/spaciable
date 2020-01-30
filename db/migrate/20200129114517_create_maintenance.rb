class CreateMaintenance < ActiveRecord::Migration[5.0]
  def up
    create_table :maintenances do |t|
      t.references :development, foreign_key: true
      t.string :path
      t.integer :account_type
      t.boolean :populate, default: true
    end

    developments = Development.where.not(maintenance_link: nil)
                              .where.not(maintenance_link: "")

    @type = 0

    developments.each do |development|
      execute "insert into maintenances (development_id, path, account_type, populate)
               values (#{development.id}, '#{development.maintenance_link}', #{@type},
               #{development.maintenance_auto_populate})"
    end

    remove_column :developments, :maintenance_auto_populate
    remove_column :developments, :maintenance_link
  end

  def down
    maintenances = Maintenance.all
    maintenances.each do |maintenance|
      maintenance.destroy!
    end
    drop_table :maintenances

    add_column :developments, :maintenance_auto_populate, :boolean, default: true
    add_column :developments, :maintenance_link, :string
  end
end