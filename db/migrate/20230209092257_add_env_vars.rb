class AddEnvVars < ActiveRecord::Migration[5.0]
  def change
    create_table :env_vars do |t|
      t.string :name
      t.string :value
    end

    Rake::Task['env_vars:initialise'].invoke
  end
end
