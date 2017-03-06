class CreateDefaultFaqs < ActiveRecord::Migration[5.0]
  def change
    create_table :default_faqs do |t|
      t.text :question
      t.text :answer
      t.string :category

      t.timestamps
    end
  end
end
