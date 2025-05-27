class Living < ActiveRecord::Migration[5.0]
  def change
    add_column :developments, :client_platform, :integer, default: Development.client_platforms[:native]
  end
end
