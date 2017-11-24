class AddHomeownerSearchIndexes < ActiveRecord::Migration[5.0]
  def change
    add_index :appliances, 'lower(model_num) varchar_pattern_ops', name: "search_index_on_appliance_model_num"
    add_index :appliance_manufacturers, 'lower(name) varchar_pattern_ops', name: "search_index_on_appliance_manufacturer_name"
    add_index :rooms, 'lower(name) varchar_pattern_ops', name: "search_index_on_room_name"
    add_index :documents, 'lower(title) varchar_pattern_ops', name: "search_index_on_document_title"
    add_index :contacts, 'lower(first_name) varchar_pattern_ops', name: "search_index_on_contact_first_name"
    add_index :contacts, 'lower(last_name) varchar_pattern_ops', name: "search_index_on_contact_last_name"
    add_index :contacts, 'lower(position) varchar_pattern_ops', name: "search_index_on_contact_position"
    add_index :faqs, 'lower(question) varchar_pattern_ops', name: "search_index_on_faq_question"
    add_index :finishes, 'lower(name) varchar_pattern_ops', name: "search_index_on_finish_name"
    add_index :notifications, 'lower(subject) varchar_pattern_ops', name: "search_index_on_notification_subject"
    add_index :notifications, 'lower(message) varchar_pattern_ops', name: "search_index_on_notification_message"
    add_index :how_tos, 'lower(summary) varchar_pattern_ops', name: "search_index_on_how_to_summary"
    add_index :how_tos, 'lower(description) varchar_pattern_ops', name: "search_index_on_how_to_description"
  end
end
