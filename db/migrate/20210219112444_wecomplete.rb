class Wecomplete < ActiveRecord::Migration[5.0]
  def change
    add_column :developers, :conveyancing, :boolean, default: false
    add_column :developers, :wecomplete_sign_in, :string
    add_column :developers, :wecomplete_quote, :string
    add_column :divisions, :conveyancing, :boolean, default: false
    add_column :divisions, :wecomplete_sign_in, :string
    add_column :divisions, :wecomplete_quote, :string
    add_column :developments, :conveyancing, :boolean, default: false
  end
end
