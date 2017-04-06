class AddLinkToHowTos < ActiveRecord::Migration[5.0]
  def change
    add_column :how_tos, :url, :string
    add_column :how_tos, :additional_text, :string
  end
end
