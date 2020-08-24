class GlobalFaqs < ActiveRecord::Migration[5.0]
  def change

    # First create all the reference tables

    # e.g 'residental', 'commercial'
    create_table :construction_types do |t|
      t.integer :construction
    end

    create_table :faq_types do |t|
      t.string :name
      t.string :icon
      t.boolean :default_type, default: false
      t.references :country, foreign_key: true
      t.references :construction_type, foreign_key: true
    end

    create_table :faq_categories do |t|
      t.string :name
    end

    create_table :faq_type_categories do |t|
      t.references :faq_type, foreign_key: true
      t.references :faq_category, foreign_key: true
    end

    # FAQs now have reference to a faq_type and category
    add_reference :default_faqs, :faq_type, index: true
    add_reference :default_faqs, :faq_category, index: true
    add_reference :faqs, :faq_type, index: true
    add_reference :faqs, :faq_category, index: true

    # load reference data and update faq records
    load Rails.root.join("db/seeds", "faq.rb")

    # remove category and country from DefaultFAQ table
    # remove category from Faq table
  end
end
