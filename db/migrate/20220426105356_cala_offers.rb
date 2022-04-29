class CalaOffers < ActiveRecord::Migration[5.0]
  def change
    add_column :developers, :verified_association, :integer, default: Developer.verified_associations[:unverified]
  end
end
