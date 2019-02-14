class PopulateCountries < ActiveRecord::Migration[5.0]
  def change

    ########################
	# => Add Countries
	########################
	countries =
	[
  		"UK",
  		"Spain"
	].each { |name| Country.find_or_create_by(name: name) }

  add_column :how_tos, :country_id, :integer, null: false, :default => Country.first.id
  change_column :how_tos, :country_id, :integer, default: nil
  add_column :default_faqs, :country_id, :integer, null: false, :default => Country.first.id
  change_column :default_faqs, :country_id, :integer, default: nil
  add_column :developers, :country_id, :integer, null: false, :default => Country.first.id
  change_column :developers, :country_id, :integer, default: nil

  [
    "Buying in Spain",
    "Furnishing and Maintaining Your Property",
    "Holiday Home Running Costs" ,
    "Rental Appeal" ,
    "Permanent Living in Spain"
  ].each do | parent_name |
      sub_category = HowToSubCategory.find_or_initialize_by(parent_category: parent_name, name: parent_name)
      sub_category.parent_category = parent_name
      sub_category.save!
    end

  end
end
