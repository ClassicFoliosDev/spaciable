class AddOrganisationToContact < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :organisation, :string
  end
end
