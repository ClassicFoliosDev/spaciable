class AddChoiceArchive < ActiveRecord::Migration[5.0]
  def change

    add_column :choices, :archived, :boolean, default: false
    add_column :choice_configurations, :archived, :boolean, default: false
    add_column :users, :receive_choice_emails, :boolean, default: false

  end
end
