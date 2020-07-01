class AddFaqFeedbackToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :receive_faq_emails, :boolean, default: false
  end
end
