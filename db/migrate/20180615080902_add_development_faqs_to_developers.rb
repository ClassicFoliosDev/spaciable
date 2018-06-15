class AddDevelopmentFaqsToDevelopers < ActiveRecord::Migration[5.0]
  def change
    add_column :developers, :development_faqs, :boolean, default: :false
  end
end
