class RemoveSubjectSearch < ActiveRecord::Migration[5.0]
  def change
    remove_index :faqs, name: :search_index_on_faq_answer
  end
end
