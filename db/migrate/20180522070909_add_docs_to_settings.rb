class AddDocsToSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :cookie_policy, :string
    add_column :settings, :cookie_short_name, :string
    add_column :settings, :privacy_policy, :string
    add_column :settings, :privacy_short_name, :string
    add_column :settings, :help, :string
    add_column :settings, :help_short_name, :string
  end
end
