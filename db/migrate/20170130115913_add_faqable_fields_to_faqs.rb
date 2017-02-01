class AddFaqableFieldsToFaqs < ActiveRecord::Migration[5.0]
  def change
    add_reference :faqs, :faqable, polymorphic: true
  end
end
