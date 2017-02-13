class AddPermissionIdsToFaqs < ActiveRecord::Migration[5.0]
  def change
    add_reference :faqs, :developer, foreign_key: true
    add_reference :faqs, :division, foreign_key: true
    add_reference :faqs, :development, foreign_key: true
  end
end
