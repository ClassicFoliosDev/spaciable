class Unlatch < ActiveRecord::Migration[5.0]
  def change
    add_column :phases, :unlatch_program_id, :integer
    add_column :developers, :unlatch_developer_id, :integer

    create_table :unlatch_documents do |t|
      t.references :unlatch_lot, index: true
      t.references :document, index: true
    end

    create_table :unlatch_lots do |t|
      t.references :plot, index: true
      t.integer :sync_status, default: 0
      t.datetime :sync_date
    end

  end
end
