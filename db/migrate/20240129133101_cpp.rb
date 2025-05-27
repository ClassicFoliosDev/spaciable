class Cpp < ActiveRecord::Migration[5.2]
  def change
    add_column :phases, :cpp, :float, default: 0.0
    add_column :invoices, :cpp, :float, default: 0.0

    create_table :cpps do |t|
      t.integer :package
      t.float   :value, default: 0.0
    end

    Rake::Task['phase_cpps:migrate'].invoke
  end
end
