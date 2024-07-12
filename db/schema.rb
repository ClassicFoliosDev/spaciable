# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_07_03_141434) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "access_tokens", id: :serial, force: :cascade do |t|
    t.string "access_token"
    t.string "refresh_token"
    t.integer "expires_at"
    t.integer "crm_id"
    t.index ["crm_id"], name: "index_access_tokens_on_crm_id"
  end

  create_table "actions", id: :serial, force: :cascade do |t|
    t.integer "task_id"
    t.string "title"
    t.text "description"
    t.string "link"
    t.integer "feature_type", default: 0
    t.index ["task_id"], name: "index_actions_on_task_id"
  end

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.string "postal_number"
    t.string "city"
    t.string "county"
    t.string "postcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "building_name"
    t.string "road_name"
    t.datetime "deleted_at"
    t.string "addressable_type"
    t.integer "addressable_id"
    t.string "locality"
    t.string "prefix"
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id"
    t.index ["deleted_at"], name: "index_addresses_on_deleted_at"
  end

  create_table "admin_notifications", id: :serial, force: :cascade do |t|
    t.string "subject"
    t.text "message"
    t.datetime "sent_at"
    t.integer "author_id"
    t.integer "sender_id"
    t.datetime "created_at", null: false
    t.boolean "send_to_all", default: false
    t.datetime "updated_at", null: false
    t.string "send_to_type"
    t.integer "send_to_id"
    t.index ["author_id"], name: "index_admin_notifications_on_author_id"
    t.index ["send_to_type", "send_to_id"], name: "index_admin_notifications_on_send_to_type_and_send_to_id"
    t.index ["sender_id"], name: "index_admin_notifications_on_sender_id"
  end

  create_table "ahoy_events", id: :serial, force: :cascade do |t|
    t.integer "visit_id"
    t.string "userable_type"
    t.integer "userable_id"
    t.string "name"
    t.integer "plot_id"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties_jsonb_path_ops", opclass: :jsonb_path_ops, using: :gin
    t.index ["userable_type", "userable_id"], name: "index_ahoy_events_on_userable_type_and_userable_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", id: :serial, force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.string "userable_type"
    t.integer "userable_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.datetime "started_at"
    t.index ["userable_type", "userable_id"], name: "index_ahoy_visits_on_userable_type_and_userable_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "appliance_categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "register", default: true
  end

  create_table "appliance_manufacturers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "deleted_at"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((name)::text) varchar_pattern_ops", name: "search_index_on_appliance_manufacturer_name"
  end

  create_table "appliances", id: :serial, force: :cascade do |t|
    t.string "primary_image"
    t.string "manual"
    t.string "service_log"
    t.string "warranty_num"
    t.integer "warranty_length"
    t.string "model_num"
    t.integer "e_rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "description"
    t.string "secondary_image"
    t.string "document"
    t.integer "appliance_category_id"
    t.string "guide"
    t.integer "appliance_manufacturer_id"
    t.integer "developer_id"
    t.integer "main_uk_e_rating"
    t.integer "supp_uk_e_rating"
    t.index "lower((model_num)::text) varchar_pattern_ops", name: "search_index_on_appliance_model_num"
    t.index ["appliance_category_id"], name: "index_appliances_on_appliance_category_id"
    t.index ["appliance_manufacturer_id"], name: "index_appliances_on_appliance_manufacturer_id"
    t.index ["deleted_at"], name: "index_appliances_on_deleted_at"
  end

  create_table "appliances_rooms", id: :serial, force: :cascade do |t|
    t.integer "appliance_id", null: false
    t.integer "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appliance_id", "room_id"], name: "appliance_room_index"
    t.index ["room_id", "appliance_id"], name: "room_appliance_index"
  end

  create_table "branded_apps", id: :serial, force: :cascade do |t|
    t.string "app_owner_type"
    t.integer "app_owner_id"
    t.string "android_link"
    t.string "apple_link"
    t.string "app_icon"
    t.index ["app_owner_type", "app_owner_id"], name: "index_branded_apps_on_app_owner_type_and_app_owner_id"
  end

  create_table "branded_perks", id: :serial, force: :cascade do |t|
    t.integer "developer_id"
    t.string "link"
    t.string "account_number"
    t.string "tile_image"
    t.index ["developer_id"], name: "index_branded_perks_on_developer_id"
  end

  create_table "brands", id: :serial, force: :cascade do |t|
    t.string "logo"
    t.string "banner"
    t.string "bg_color"
    t.string "text_color"
    t.string "content_bg_color"
    t.string "content_text_color"
    t.string "button_color"
    t.string "button_text_color"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "brandable_type"
    t.integer "brandable_id"
    t.string "header_color"
    t.string "login_image"
    t.string "topnav_text"
    t.string "topnav_text_color"
    t.string "login_box_left_color"
    t.string "login_box_right_color"
    t.string "login_button_static_color"
    t.string "login_button_hover_color"
    t.string "content_box_color"
    t.string "content_box_outline_color"
    t.string "text_left_color"
    t.string "text_right_color"
    t.string "login_logo"
    t.string "content_box_text"
    t.string "heading_one"
    t.string "heading_two"
    t.string "info_text"
    t.string "email_logo"
    t.string "font"
    t.integer "border_style"
    t.integer "button_style"
    t.integer "hero_height"
    t.index ["brandable_type", "brandable_id"], name: "index_brands_on_brandable_type_and_brandable_id"
  end

  create_table "build_sequences", id: :serial, force: :cascade do |t|
    t.string "build_sequenceable_type"
    t.integer "build_sequenceable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "build_steps", id: :serial, force: :cascade do |t|
    t.integer "build_sequence_id", null: false
    t.string "title", null: false
    t.string "description", null: false
    t.integer "order", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["build_sequence_id"], name: "index_build_steps_on_build_sequence_id"
  end

  create_table "cc_emails", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "email_type"
    t.string "email_list"
    t.index ["user_id"], name: "index_cc_emails_on_user_id"
  end

  create_table "chart_colours", id: :serial, force: :cascade do |t|
    t.integer "key"
    t.string "colour", default: "#ffffff"
  end

  create_table "charts", id: :serial, force: :cascade do |t|
    t.string "chartable_type"
    t.integer "chartable_id"
    t.integer "section"
    t.boolean "enabled"
    t.index ["chartable_type", "chartable_id"], name: "index_charts_on_chartable_type_and_chartable_id"
  end

  create_table "choice_configurations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "development_id"
    t.boolean "archived", default: false
    t.index ["development_id"], name: "index_choice_configurations_on_development_id"
  end

  create_table "choices", id: :serial, force: :cascade do |t|
    t.string "choiceable_type"
    t.integer "choiceable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "room_item_id"
    t.boolean "archived", default: false
    t.index ["choiceable_type", "choiceable_id"], name: "index_choices_on_choiceable_type_and_choiceable_id"
    t.index ["room_item_id"], name: "index_choices_on_room_item_id"
  end

  create_table "ckeditor_assets", id: :serial, force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "clients", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["email"], name: "index_clients_on_email", unique: true
    t.index ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true
  end

  create_table "construction_types", id: :serial, force: :cascade do |t|
    t.integer "construction"
  end

  create_table "contacts", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "title"
    t.string "position"
    t.integer "category"
    t.string "email"
    t.string "phone"
    t.string "mobile"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
    t.string "contactable_type"
    t.integer "contactable_id"
    t.string "organisation"
    t.boolean "pinned", default: false
    t.integer "contact_type", default: 0
    t.index "lower((\"position\")::text) varchar_pattern_ops", name: "search_index_on_contact_position"
    t.index "lower((first_name)::text) varchar_pattern_ops", name: "search_index_on_contact_first_name"
    t.index "lower((last_name)::text) varchar_pattern_ops", name: "search_index_on_contact_last_name"
    t.index ["contactable_type", "contactable_id"], name: "index_contacts_on_contactable_type_and_contactable_id"
    t.index ["deleted_at"], name: "index_contacts_on_deleted_at"
  end

  create_table "countries", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "time_zone"
  end

  create_table "cpps", force: :cascade do |t|
    t.integer "package"
    t.float "value", default: 0.0
  end

  create_table "crms", id: :serial, force: :cascade do |t|
    t.integer "developer_id"
    t.string "name"
    t.string "client_id"
    t.string "client_secret"
    t.string "redirect_uri"
    t.string "current_user_email"
    t.string "accounts_url"
    t.string "api_base_url"
    t.string "token_persistence_path"
    t.index ["developer_id"], name: "index_crms_on_developer_id"
  end

  create_table "custom_tiles", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "button"
    t.string "image"
    t.integer "category", default: 0
    t.string "link"
    t.integer "feature"
    t.integer "guide"
    t.string "file"
    t.integer "document_id"
    t.string "tileable_type"
    t.integer "tileable_id"
    t.boolean "render_title", default: true
    t.boolean "render_description", default: true
    t.boolean "render_button", default: true
    t.boolean "full_image", default: false
    t.integer "spotlight_id"
    t.integer "order", default: 0
    t.string "original_filename"
    t.index ["document_id"], name: "index_custom_tiles_on_document_id"
    t.index ["spotlight_id"], name: "index_custom_tiles_on_spotlight_id"
    t.index ["tileable_type", "tileable_id"], name: "index_custom_tiles_on_tileable_type_and_tileable_id"
  end

  create_table "default_faqs", id: :serial, force: :cascade do |t|
    t.text "question"
    t.text "answer"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "country_id", null: false
    t.integer "faq_type_id"
    t.integer "faq_category_id"
    t.integer "faq_package", default: 0
    t.index ["faq_category_id"], name: "index_default_faqs_on_faq_category_id"
    t.index ["faq_type_id"], name: "index_default_faqs_on_faq_type_id"
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "developers", id: :serial, force: :cascade do |t|
    t.string "company_name"
    t.string "email"
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.text "about"
    t.string "api_key"
    t.string "list_id"
    t.integer "country_id", null: false
    t.boolean "house_search", default: true
    t.boolean "enable_services", default: true
    t.boolean "enable_development_messages", default: false
    t.boolean "development_faqs", default: false
    t.boolean "enable_roomsketcher", default: true
    t.boolean "enable_referrals", default: true
    t.boolean "cas", default: false
    t.boolean "enable_perks", default: true
    t.boolean "timeline", default: false
    t.string "custom_url"
    t.boolean "is_demo", default: false
    t.string "account_manager_name"
    t.string "account_manager_email"
    t.string "account_manager_contact"
    t.boolean "enable_how_tos", default: true
    t.boolean "conveyancing", default: false
    t.string "wecomplete_sign_in"
    t.string "wecomplete_quote"
    t.boolean "analytics_dashboard", default: true
    t.boolean "show_warranties", default: true
    t.integer "verified_association", default: 0
    t.integer "auto_complete", default: 24
    t.index ["company_name"], name: "index_developers_on_company_name", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_developers_on_deleted_at"
  end

  create_table "development_messages", id: :serial, force: :cascade do |t|
    t.string "subject"
    t.string "content"
    t.integer "parent_id"
    t.integer "development_id"
    t.integer "resident_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["development_id"], name: "index_development_messages_on_development_id"
    t.index ["parent_id"], name: "index_development_messages_on_parent_id"
    t.index ["resident_id"], name: "index_development_messages_on_resident_id"
  end

  create_table "developments", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "developer_id"
    t.string "email"
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "division_id"
    t.datetime "deleted_at"
    t.integer "phases_count", default: 0
    t.string "segment_id"
    t.integer "choice_option", default: 0, null: false
    t.string "choices_email_contact"
    t.boolean "enable_snagging", default: true
    t.integer "snag_duration", default: 14
    t.string "snag_name", default: "Snagging", null: false
    t.boolean "cas", default: false
    t.integer "construction", default: 0, null: false
    t.string "construction_name"
    t.boolean "calendar", default: true
    t.boolean "conveyancing", default: false
    t.boolean "analytics_dashboard", default: true
    t.integer "client_platform", default: 0
    t.index ["deleted_at"], name: "index_developments_on_deleted_at"
    t.index ["developer_id"], name: "index_developments_on_developer_id"
    t.index ["division_id"], name: "index_developments_on_division_id"
    t.index ["name", "developer_id", "division_id"], name: "index_developments_on_name_and_developer_id_and_division_id", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "divisions", id: :serial, force: :cascade do |t|
    t.string "division_name"
    t.string "email"
    t.string "contact_number"
    t.integer "developer_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "list_id"
    t.boolean "conveyancing", default: false
    t.string "wecomplete_sign_in"
    t.string "wecomplete_quote"
    t.boolean "analytics_dashboard", default: true
    t.index ["created_at"], name: "index_divisions_on_created_at"
    t.index ["deleted_at"], name: "index_divisions_on_deleted_at"
    t.index ["developer_id"], name: "index_divisions_on_developer_id"
    t.index ["division_name", "developer_id"], name: "index_divisions_on_division_name_and_developer_id", unique: true, where: "(deleted_at IS NULL)"
    t.index ["updated_at"], name: "index_divisions_on_updated_at"
  end

  create_table "documents", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "documentable_type"
    t.integer "documentable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file"
    t.string "original_filename"
    t.integer "category"
    t.boolean "pinned", default: false
    t.string "file_tmp"
    t.integer "user_id"
    t.integer "guide"
    t.boolean "lau_visible", default: false
    t.boolean "override", default: false
    t.index "lower((title)::text) varchar_pattern_ops", name: "search_index_on_document_title"
    t.index ["documentable_type", "documentable_id"], name: "index_documents_on_documentable_type_and_documentable_id"
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "documents_plots", id: :serial, force: :cascade do |t|
    t.integer "document_id", null: false
    t.integer "plot_id", null: false
    t.boolean "enable_tenant_read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id", "plot_id"], name: "document_plot_index"
    t.index ["plot_id", "document_id"], name: "plot_document_index"
  end

  create_table "env_vars", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "value"
  end

  create_table "event_resources", id: :serial, force: :cascade do |t|
    t.integer "event_id"
    t.string "resourceable_type"
    t.integer "resourceable_id"
    t.integer "status"
    t.datetime "status_updated_at"
    t.index ["event_id"], name: "index_event_resources_on_event_id"
    t.index ["resourceable_type", "resourceable_id"], name: "index_event_resources_on_resourceable_type_and_resourceable_id"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "eventable_type"
    t.integer "eventable_id"
    t.string "userable_type"
    t.integer "userable_id"
    t.integer "master_id"
    t.string "title"
    t.string "location"
    t.datetime "start"
    t.datetime "end"
    t.integer "repeat"
    t.datetime "repeat_until"
    t.integer "reminder"
    t.integer "reminder_id"
    t.datetime "proposed_start"
    t.datetime "proposed_end"
    t.boolean "notify", default: true
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }
    t.index ["eventable_type", "eventable_id"], name: "index_events_on_eventable_type_and_eventable_id"
    t.index ["master_id"], name: "index_events_on_master_id"
    t.index ["userable_type", "userable_id"], name: "index_events_on_userable_type_and_userable_id"
  end

  create_table "faq_categories", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "faq_type_categories", id: :serial, force: :cascade do |t|
    t.integer "faq_type_id"
    t.integer "faq_category_id"
    t.index ["faq_category_id"], name: "index_faq_type_categories_on_faq_category_id"
    t.index ["faq_type_id"], name: "index_faq_type_categories_on_faq_type_id"
  end

  create_table "faq_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "icon"
    t.boolean "default_type", default: false
    t.integer "country_id"
    t.integer "construction_type_id"
    t.index ["construction_type_id"], name: "index_faq_types_on_construction_type_id"
    t.index ["country_id"], name: "index_faq_types_on_country_id"
  end

  create_table "faqs", id: :serial, force: :cascade do |t|
    t.text "question"
    t.text "answer"
    t.integer "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "faqable_type"
    t.integer "faqable_id"
    t.integer "faq_type_id"
    t.integer "faq_category_id"
    t.integer "faq_package"
    t.index "lower(question) varchar_pattern_ops", name: "search_index_on_faq_question"
    t.index ["faq_category_id"], name: "index_faqs_on_faq_category_id"
    t.index ["faq_type_id"], name: "index_faqs_on_faq_type_id"
    t.index ["faqable_type", "faqable_id"], name: "index_faqs_on_faqable_type_and_faqable_id"
  end

  create_table "features", id: :serial, force: :cascade do |t|
    t.integer "task_id"
    t.string "title"
    t.text "description"
    t.string "link"
    t.string "precis"
    t.integer "feature_type", default: 0
    t.index ["task_id"], name: "index_features_on_task_id"
  end

  create_table "finales", id: :serial, force: :cascade do |t|
    t.integer "timeline_id"
    t.string "complete_picture"
    t.text "complete_message"
    t.string "incomplete_picture"
    t.text "incomplete_message"
    t.index ["timeline_id"], name: "index_finales_on_timeline_id"
  end

  create_table "finish_categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "finish_categories_types", id: false, force: :cascade do |t|
    t.integer "finish_category_id", null: false
    t.integer "finish_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["finish_category_id", "finish_type_id"], name: "finish_category_finish_type_index"
    t.index ["finish_type_id", "finish_category_id"], name: "finish_type_finish_category_index"
  end

  create_table "finish_manufacturers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "developer_id"
    t.index "lower((name)::text) varchar_pattern_ops", name: "search_index_on_finish_manufacturer_name"
  end

  create_table "finish_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((name)::text) varchar_pattern_ops", name: "search_index_on_finish_type_name"
  end

  create_table "finish_types_manufacturers", id: false, force: :cascade do |t|
    t.integer "finish_type_id", null: false
    t.integer "manufacturer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "finish_manufacturer_id"
    t.index ["finish_manufacturer_id"], name: "index_finish_types_manufacturers_on_finish_manufacturer_id"
    t.index ["finish_type_id"], name: "index_finish_types_manufacturers_on_finish_type_id"
  end

  create_table "finishes", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
    t.datetime "deleted_at"
    t.string "description"
    t.integer "finish_category_id"
    t.integer "finish_type_id"
    t.integer "finish_manufacturer_id"
    t.string "original_filename"
    t.integer "developer_id"
    t.index "lower((name)::text) varchar_pattern_ops", name: "search_index_on_finish_name"
    t.index ["deleted_at"], name: "index_finishes_on_deleted_at"
    t.index ["finish_category_id"], name: "index_finishes_on_finish_category_id"
    t.index ["finish_manufacturer_id"], name: "index_finishes_on_finish_manufacturer_id"
    t.index ["finish_type_id"], name: "index_finishes_on_finish_type_id"
    t.index ["name", "finish_category_id", "finish_type_id", "finish_manufacturer_id", "developer_id"], name: "index_finishes_on_combo", unique: true
  end

  create_table "finishes_rooms", id: :serial, force: :cascade do |t|
    t.integer "finish_id", null: false
    t.integer "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["finish_id", "room_id"], name: "finish_room_index"
    t.index ["room_id", "finish_id"], name: "room_finish_index"
  end

  create_table "globals", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "grants", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role"
    t.string "permission_level_type"
    t.integer "permission_level_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_level_type", "permission_level_id"], name: "index_grants_on_permission_level_type_and_permission_level_id"
    t.index ["user_id"], name: "index_grants_on_user_id"
  end

  create_table "how_to_sub_categories", id: :serial, force: :cascade do |t|
    t.text "name"
    t.text "parent_category"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "how_tos", id: :serial, force: :cascade do |t|
    t.text "title"
    t.text "summary"
    t.text "description"
    t.integer "category"
    t.integer "featured"
    t.string "picture"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.string "additional_text"
    t.integer "how_to_sub_category_id"
    t.integer "country_id", null: false
    t.boolean "hide", default: false
    t.index "lower(summary) varchar_pattern_ops", name: "search_index_on_how_to_summary"
    t.index "lower(title) varchar_pattern_ops", name: "search_index_on_how_to_title"
    t.index ["how_to_sub_category_id"], name: "index_how_tos_on_how_to_sub_category_id"
  end

  create_table "how_tos_tags", id: false, force: :cascade do |t|
    t.integer "how_to_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["how_to_id", "tag_id"], name: "how_to_tag_index"
    t.index ["tag_id", "how_to_id"], name: "tag_how_to_index"
  end

  create_table "invoices", id: :serial, force: :cascade do |t|
    t.integer "phase_id"
    t.integer "package"
    t.integer "plots"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ff_plots", default: 0
    t.float "cpp", default: 0.0
    t.index ["phase_id"], name: "index_invoices_on_phase_id"
  end

  create_table "lettings_accounts", id: :serial, force: :cascade do |t|
    t.string "reference"
    t.integer "access_token_id"
    t.integer "authorisation_status", default: 0
    t.integer "management", default: 0
    t.string "accountable_type"
    t.integer "accountable_id"
    t.index ["access_token_id"], name: "index_lettings_accounts_on_access_token_id"
    t.index ["accountable_type", "accountable_id"], name: "index_lettings_accounts_on_accountable_type_and_accountable_id"
  end

  create_table "listings", id: :serial, force: :cascade do |t|
    t.string "reference"
    t.string "other_ref"
    t.integer "owner", null: false
    t.integer "lettings_account_id"
    t.integer "plot_id", null: false
    t.index ["lettings_account_id"], name: "index_listings_on_lettings_account_id"
    t.index ["plot_id"], name: "index_listings_on_plot_id", unique: true
  end

  create_table "locks", id: :serial, force: :cascade do |t|
    t.integer "job", null: false
    t.index ["job"], name: "index_locks_on_job", unique: true
  end

  create_table "logs", id: :serial, force: :cascade do |t|
    t.string "logable_type"
    t.integer "logable_id"
    t.string "primary"
    t.string "secondary"
    t.integer "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["logable_type", "logable_id"], name: "index_logs_on_logable_type_and_logable_id"
  end

  create_table "lookups", id: :serial, force: :cascade do |t|
    t.string "code"
    t.string "column"
    t.string "translation"
  end

  create_table "maintenances", id: :serial, force: :cascade do |t|
    t.integer "development_id"
    t.string "path"
    t.integer "account_type"
    t.boolean "populate", default: true
    t.boolean "fixflow_direct", default: false
    t.index ["development_id"], name: "index_maintenances_on_development_id"
  end

  create_table "marks", id: :serial, force: :cascade do |t|
    t.string "markable_type"
    t.integer "markable_id"
    t.string "username"
    t.integer "role"
    t.index ["markable_type", "markable_id"], name: "index_marks_on_markable_type_and_markable_id"
  end

  create_table "notifications", id: :serial, force: :cascade do |t|
    t.string "subject"
    t.text "message"
    t.datetime "sent_at"
    t.integer "author_id"
    t.integer "sender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "send_to_type"
    t.integer "send_to_id"
    t.boolean "send_to_all", default: false
    t.string "plot_numbers", array: true
    t.string "plot_prefix"
    t.integer "send_to_role"
    t.integer "plot_filter", default: 0
    t.index "lower((subject)::text) varchar_pattern_ops", name: "search_index_on_notification_subject"
    t.index ["author_id"], name: "index_notifications_on_author_id"
    t.index ["send_to_type", "send_to_id"], name: "index_notifications_on_send_to_type_and_send_to_id"
    t.index ["sender_id"], name: "index_notifications_on_sender_id"
  end

  create_table "oauth_access_grants", id: :serial, force: :cascade do |t|
    t.string "resource_type"
    t.integer "resource_id"
    t.integer "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_type", "resource_id"], name: "index_oauth_access_grants_on_resource_type_and_resource_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", id: :serial, force: :cascade do |t|
    t.string "resource_type"
    t.integer "resource_id"
    t.integer "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_type", "resource_id"], name: "index_oauth_access_tokens_on_resource_type_and_resource_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "pg_search_documents", id: :serial, force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.integer "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "phase_timelines", id: :serial, force: :cascade do |t|
    t.integer "timeline_id"
    t.integer "phase_id"
    t.index ["phase_id"], name: "index_phase_timelines_on_phase_id"
    t.index ["timeline_id"], name: "index_phase_timelines_on_timeline_id"
  end

  create_table "phases", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "development_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "developer_id"
    t.integer "division_id"
    t.integer "number"
    t.datetime "deleted_at"
    t.integer "total_snags", default: 0
    t.integer "unresolved_snags", default: 0
    t.integer "business", default: 0
    t.boolean "conveyancing", default: true
    t.integer "package", default: 3
    t.float "cpp", default: 0.0
    t.index ["deleted_at"], name: "index_phases_on_deleted_at"
    t.index ["developer_id"], name: "index_phases_on_developer_id"
    t.index ["development_id"], name: "index_phases_on_development_id"
    t.index ["division_id"], name: "index_phases_on_division_id"
    t.index ["name", "development_id"], name: "index_phases_on_name_and_development_id", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "plot_residencies", id: :serial, force: :cascade do |t|
    t.integer "plot_id"
    t.integer "resident_id"
    t.date "completion_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer "role"
    t.string "invited_by_type"
    t.integer "invited_by_id"
    t.integer "task_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_plot_residencies_on_invited_by_type_and_invited_by_id"
    t.index ["plot_id"], name: "index_plot_residencies_on_plot_id"
    t.index ["resident_id"], name: "index_plot_residencies_on_resident_id"
    t.index ["task_id"], name: "index_plot_residencies_on_task_id"
  end

  create_table "plot_timeline_stages", id: :serial, force: :cascade do |t|
    t.integer "plot_timeline_id"
    t.integer "timeline_stage_id"
    t.boolean "collapsed", default: false
    t.index ["plot_timeline_id"], name: "index_plot_timeline_stages_on_plot_timeline_id"
    t.index ["timeline_stage_id"], name: "index_plot_timeline_stages_on_timeline_stage_id"
  end

  create_table "plot_timelines", id: :serial, force: :cascade do |t|
    t.integer "phase_timeline_id"
    t.integer "plot_id"
    t.integer "task_id"
    t.boolean "complete", default: false
    t.index ["phase_timeline_id"], name: "index_plot_timelines_on_phase_timeline_id"
    t.index ["plot_id"], name: "index_plot_timelines_on_plot_id"
    t.index ["task_id"], name: "index_plot_timelines_on_task_id"
  end

  create_table "plots", id: :serial, force: :cascade do |t|
    t.string "number"
    t.integer "unit_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "developer_id"
    t.integer "division_id"
    t.integer "development_id"
    t.datetime "deleted_at"
    t.integer "phase_id"
    t.string "house_number"
    t.integer "progress", default: 0
    t.date "completion_date"
    t.date "completion_release_date"
    t.date "reservation_release_date"
    t.integer "validity", default: 27
    t.integer "extended_access", default: 0
    t.integer "choice_configuration_id"
    t.integer "choice_selection_status", default: 0, null: false
    t.integer "total_snags", default: 0
    t.integer "unresolved_snags", default: 0
    t.string "completion_order_number"
    t.string "reservation_order_number"
    t.string "uprn"
    t.integer "build_step_id"
    t.datetime "auto_completed"
    t.index ["build_step_id"], name: "index_plots_on_build_step_id"
    t.index ["deleted_at"], name: "index_plots_on_deleted_at"
    t.index ["developer_id"], name: "index_plots_on_developer_id"
    t.index ["development_id"], name: "index_plots_on_development_id"
    t.index ["division_id"], name: "index_plots_on_division_id"
    t.index ["phase_id"], name: "index_plots_on_phase_id"
    t.index ["unit_type_id"], name: "index_plots_on_unit_type_id"
  end

  create_table "plots_private_documents", id: :serial, force: :cascade do |t|
    t.integer "private_document_id", null: false
    t.integer "plot_id", null: false
    t.boolean "enable_tenant_read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plot_id", "private_document_id"], name: "plot_private_document_index"
    t.index ["private_document_id", "plot_id"], name: "private_document_plot_index"
  end

  create_table "premium_perks", id: :serial, force: :cascade do |t|
    t.integer "development_id"
    t.boolean "enable_premium_perks", default: false
    t.integer "premium_licences_bought"
    t.integer "premium_licence_duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sign_up_count", default: 0
    t.index ["development_id"], name: "index_premium_perks_on_development_id"
  end

  create_table "private_documents", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "file"
    t.integer "resident_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "plot_id"
    t.index ["plot_id"], name: "index_private_documents_on_plot_id"
    t.index ["resident_id"], name: "index_private_documents_on_resident_id"
  end

  create_table "referrals", id: :serial, force: :cascade do |t|
    t.string "referrer_name"
    t.string "referrer_email"
    t.string "referrer_developer"
    t.string "referrer_address"
    t.string "referee_first_name"
    t.string "referee_last_name"
    t.string "referee_email"
    t.string "referee_phone"
    t.datetime "referral_date"
    t.boolean "email_confirmed", default: false
    t.string "confirm_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "resident_notifications", id: :serial, force: :cascade do |t|
    t.integer "resident_id"
    t.integer "notification_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "read_at"
    t.index ["notification_id"], name: "index_resident_notifications_on_notification_id"
    t.index ["resident_id"], name: "index_resident_notifications_on_resident_id"
  end

  create_table "residents", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "title", default: 0
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.integer "invited_by_id"
    t.integer "invitations_count", default: 0
    t.integer "developer_email_updates"
    t.integer "cf_email_updates"
    t.integer "telephone_updates"
    t.string "phone_number"
    t.datetime "ts_and_cs_accepted_at"
    t.datetime "extended_until"
    t.boolean "living", default: false
    t.index ["email"], name: "index_residents_on_email", unique: true
    t.index ["invitation_token"], name: "index_residents_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_residents_on_invitations_count"
    t.index ["invited_by_id"], name: "index_residents_on_invited_by_id"
    t.index ["invited_by_type"], name: "index_residents_on_invited_by_type"
    t.index ["reset_password_token"], name: "index_residents_on_reset_password_token", unique: true
  end

  create_table "room_choices", id: :serial, force: :cascade do |t|
    t.integer "plot_id"
    t.integer "room_item_id"
    t.integer "choice_id"
    t.index ["choice_id"], name: "index_room_choices_on_choice_id"
    t.index ["plot_id"], name: "index_room_choices_on_plot_id"
    t.index ["room_item_id"], name: "index_room_choices_on_room_item_id"
  end

  create_table "room_configurations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "icon_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "choice_configuration_id"
    t.index ["choice_configuration_id"], name: "index_room_configurations_on_choice_configuration_id"
  end

  create_table "room_items", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "room_itemable_type"
    t.integer "room_itemable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "room_configuration_id"
    t.index ["room_configuration_id"], name: "index_room_items_on_room_configuration_id"
    t.index ["room_itemable_type", "room_itemable_id"], name: "index_room_items_on_room_itemable_type_and_room_itemable_id"
  end

  create_table "rooms", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "unit_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "developer_id"
    t.integer "division_id"
    t.integer "development_id"
    t.datetime "deleted_at"
    t.integer "icon_name"
    t.integer "plot_id"
    t.integer "template_room_id"
    t.index "lower((name)::text) varchar_pattern_ops", name: "search_index_on_room_name"
    t.index ["deleted_at"], name: "index_rooms_on_deleted_at"
    t.index ["developer_id"], name: "index_rooms_on_developer_id"
    t.index ["development_id"], name: "index_rooms_on_development_id"
    t.index ["division_id"], name: "index_rooms_on_division_id"
    t.index ["name", "unit_type_id"], name: "index_rooms_on_name_and_unit_type_id", unique: true, where: "(deleted_at IS NULL)"
    t.index ["plot_id"], name: "index_rooms_on_plot_id"
    t.index ["unit_type_id"], name: "index_rooms_on_unit_type_id"
  end

  create_table "sessions", id: :serial, force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "settings", id: :serial, force: :cascade do |t|
    t.string "video_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cookie_policy"
    t.string "cookie_short_name"
    t.string "privacy_policy"
    t.string "privacy_short_name"
    t.string "help"
    t.string "help_short_name"
    t.boolean "intro_video_enabled", default: true
  end

  create_table "shortcuts", id: :serial, force: :cascade do |t|
    t.integer "shortcut_type"
    t.string "icon"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "snag_attachments", id: :serial, force: :cascade do |t|
    t.integer "snag_id"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "snag_comments", id: :serial, force: :cascade do |t|
    t.string "content"
    t.string "image"
    t.integer "snag_id"
    t.string "commenter_type"
    t.integer "commenter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commenter_type", "commenter_id"], name: "index_snag_comments_on_commenter_type_and_commenter_id"
    t.index ["snag_id"], name: "index_snag_comments_on_snag_id"
  end

  create_table "snags", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "status", default: 0
    t.integer "plot_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plot_id"], name: "index_snags_on_plot_id"
  end

  create_table "spotlights", id: :serial, force: :cascade do |t|
    t.integer "development_id"
    t.integer "category", default: 0
    t.boolean "cf", default: true
    t.boolean "editable", default: true
    t.boolean "all_or_nothing", default: false
    t.integer "appears", default: 0
    t.integer "expiry", default: 0
    t.date "start"
    t.date "finish"
    t.integer "sequence_no", default: -> { "nextval('spotlight_seq'::regclass)" }
  end

  create_table "stage_sets", id: :serial, force: :cascade do |t|
    t.integer "stage_set_type", default: 0
    t.boolean "clone", default: false
  end

  create_table "stages", id: :serial, force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order", default: 1
    t.integer "stage_set_id", null: false
    t.index ["stage_set_id"], name: "index_stages_on_stage_set_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.text "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "task_contacts", id: :serial, force: :cascade do |t|
    t.integer "task_id"
    t.integer "contact_type"
    t.index ["task_id"], name: "index_task_contacts_on_task_id"
  end

  create_table "task_logs", id: :serial, force: :cascade do |t|
    t.integer "plot_timeline_id"
    t.integer "task_id"
    t.integer "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plot_timeline_id"], name: "index_task_logs_on_plot_timeline_id"
    t.index ["task_id"], name: "index_task_logs_on_task_id"
  end

  create_table "task_shortcuts", id: :serial, force: :cascade do |t|
    t.integer "task_id"
    t.integer "shortcut_id"
    t.integer "order"
    t.boolean "live"
    t.index ["shortcut_id"], name: "index_task_shortcuts_on_shortcut_id"
    t.index ["task_id"], name: "index_task_shortcuts_on_task_id"
  end

  create_table "tasks", id: :serial, force: :cascade do |t|
    t.integer "timeline_id"
    t.integer "stage_id"
    t.string "picture"
    t.string "title"
    t.string "question"
    t.string "answer"
    t.boolean "not_applicable", default: false
    t.text "response"
    t.string "positive", default: "Yes"
    t.string "negative", default: "No"
    t.boolean "head", default: false
    t.integer "next_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "title_class", default: 0
    t.integer "media_type", default: 0
    t.string "video_title"
    t.string "video_link"
    t.index ["stage_id"], name: "index_tasks_on_stage_id"
    t.index ["timeline_id"], name: "index_tasks_on_timeline_id"
  end

  create_table "timeline_stages", id: :serial, force: :cascade do |t|
    t.integer "timeline_id"
    t.integer "order"
    t.integer "stage_id"
    t.index ["stage_id"], name: "index_timeline_stages_on_stage_id"
    t.index ["timeline_id"], name: "index_timeline_stages_on_timeline_id"
  end

  create_table "timelines", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "timelineable_type"
    t.integer "timelineable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "stage_set_id", null: false
    t.string "description", default: "Track your progress towards your move and pick up plenty of tips along the way."
    t.index ["stage_set_id"], name: "index_timelines_on_stage_set_id"
    t.index ["timelineable_type", "timelineable_id"], name: "index_timelines_on_timelineable_type_and_timelineable_id"
  end

  create_table "tour_steps", id: :serial, force: :cascade do |t|
    t.integer "sequence"
    t.string "selector"
    t.string "intro"
    t.integer "position"
  end

  create_table "unit_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "developer_id"
    t.integer "division_id"
    t.integer "development_id"
    t.integer "build_type", default: 0
    t.string "picture"
    t.string "external_link"
    t.boolean "restricted", default: false
    t.index ["developer_id"], name: "index_unit_types_on_developer_id"
    t.index ["development_id"], name: "index_unit_types_on_development_id"
    t.index ["division_id"], name: "index_unit_types_on_division_id"
    t.index ["name", "development_id"], name: "index_unit_types_on_name_and_development_id", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "unlatch_developers", id: :serial, force: :cascade do |t|
    t.integer "developer_id"
    t.string "api"
    t.string "email"
    t.string "password"
    t.string "token"
    t.datetime "expires"
    t.index ["developer_id"], name: "index_unlatch_developers_on_developer_id"
  end

  create_table "unlatch_documents", id: :serial, force: :cascade do |t|
    t.integer "document_id"
    t.integer "program_id"
    t.integer "section_id"
    t.index ["document_id"], name: "index_unlatch_documents_on_document_id"
    t.index ["program_id"], name: "index_unlatch_documents_on_program_id"
    t.index ["section_id"], name: "index_unlatch_documents_on_section_id"
  end

  create_table "unlatch_logs", id: :serial, force: :cascade do |t|
    t.string "linkable_type"
    t.integer "linkable_id"
    t.string "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unlatch_lots", id: :serial, force: :cascade do |t|
    t.integer "plot_id"
    t.integer "program_id"
    t.index ["plot_id"], name: "index_unlatch_lots_on_plot_id"
    t.index ["program_id"], name: "index_unlatch_lots_on_program_id"
  end

  create_table "unlatch_programs", id: :serial, force: :cascade do |t|
    t.integer "developer_id"
    t.integer "development_id"
    t.index ["developer_id"], name: "index_unlatch_programs_on_developer_id"
    t.index ["development_id"], name: "index_unlatch_programs_on_development_id"
  end

  create_table "unlatch_sections", id: :serial, force: :cascade do |t|
    t.integer "developer_id"
    t.integer "category"
    t.index ["developer_id"], name: "index_unlatch_sections_on_developer_id"
  end

  create_table "user_preferences", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "preference", null: false
    t.boolean "on", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_preferences_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.integer "invited_by_id"
    t.integer "invitations_count", default: 0
    t.datetime "deleted_at"
    t.string "permission_level_type"
    t.integer "permission_level_id"
    t.string "picture"
    t.string "job_title"
    t.boolean "receive_release_emails", default: true
    t.boolean "receive_choice_emails", default: false
    t.boolean "snag_notifications", default: true
    t.integer "lettings_management", default: 0
    t.boolean "cas", default: false
    t.boolean "receive_invitation_emails", default: true
    t.boolean "receive_faq_emails", default: false
    t.string "selections"
    t.integer "oauth_applications_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type"], name: "index_users_on_invited_by_type"
    t.index ["oauth_applications_id"], name: "index_users_on_oauth_applications_id"
    t.index ["permission_level_type", "permission_level_id"], name: "index_users_on_permission_level_type_and_permission_level_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "videos", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "link"
    t.string "videoable_type"
    t.integer "videoable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "override", default: false
    t.index ["videoable_type", "videoable_id"], name: "index_videos_on_videoable_type_and_videoable_id"
  end

  add_foreign_key "access_tokens", "crms"
  add_foreign_key "actions", "tasks"
  add_foreign_key "appliances", "appliance_categories"
  add_foreign_key "appliances", "appliance_manufacturers"
  add_foreign_key "appliances", "developers"
  add_foreign_key "branded_perks", "developers"
  add_foreign_key "cc_emails", "users"
  add_foreign_key "crms", "developers"
  add_foreign_key "custom_tiles", "documents"
  add_foreign_key "custom_tiles", "spotlights"
  add_foreign_key "development_messages", "developments"
  add_foreign_key "development_messages", "residents"
  add_foreign_key "developments", "developers"
  add_foreign_key "developments", "divisions"
  add_foreign_key "divisions", "developers"
  add_foreign_key "documents", "users"
  add_foreign_key "events", "events", column: "master_id"
  add_foreign_key "faq_type_categories", "faq_categories"
  add_foreign_key "faq_type_categories", "faq_types"
  add_foreign_key "faq_types", "construction_types"
  add_foreign_key "faq_types", "countries"
  add_foreign_key "features", "tasks"
  add_foreign_key "finales", "timelines"
  add_foreign_key "finish_manufacturers", "developers"
  add_foreign_key "finish_types_manufacturers", "finish_manufacturers"
  add_foreign_key "finishes", "developers"
  add_foreign_key "finishes", "finish_categories"
  add_foreign_key "finishes", "finish_manufacturers"
  add_foreign_key "finishes", "finish_types"
  add_foreign_key "grants", "users"
  add_foreign_key "how_tos", "how_to_sub_categories"
  add_foreign_key "maintenances", "developments"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "phase_timelines", "phases"
  add_foreign_key "phase_timelines", "timelines"
  add_foreign_key "phases", "developers"
  add_foreign_key "phases", "developments"
  add_foreign_key "phases", "divisions"
  add_foreign_key "plot_residencies", "plots"
  add_foreign_key "plot_residencies", "residents"
  add_foreign_key "plot_residencies", "tasks"
  add_foreign_key "plot_timelines", "phase_timelines"
  add_foreign_key "plot_timelines", "plots"
  add_foreign_key "plot_timelines", "tasks"
  add_foreign_key "plots", "developers"
  add_foreign_key "plots", "developments"
  add_foreign_key "plots", "divisions"
  add_foreign_key "plots", "phases"
  add_foreign_key "plots", "unit_types"
  add_foreign_key "premium_perks", "developments"
  add_foreign_key "private_documents", "plots"
  add_foreign_key "private_documents", "residents"
  add_foreign_key "resident_notifications", "notifications"
  add_foreign_key "rooms", "developers"
  add_foreign_key "rooms", "developments"
  add_foreign_key "rooms", "divisions"
  add_foreign_key "rooms", "plots"
  add_foreign_key "rooms", "unit_types"
  add_foreign_key "snag_comments", "snags"
  add_foreign_key "snags", "plots"
  add_foreign_key "stages", "stage_sets"
  add_foreign_key "task_contacts", "tasks"
  add_foreign_key "task_logs", "plot_timelines"
  add_foreign_key "task_logs", "tasks"
  add_foreign_key "task_shortcuts", "shortcuts"
  add_foreign_key "task_shortcuts", "tasks"
  add_foreign_key "tasks", "stages"
  add_foreign_key "tasks", "timelines"
  add_foreign_key "timeline_stages", "timelines"
  add_foreign_key "timelines", "stage_sets"
  add_foreign_key "unit_types", "developers"
  add_foreign_key "unit_types", "developments"
  add_foreign_key "unit_types", "divisions"
  add_foreign_key "users", "oauth_applications", column: "oauth_applications_id"
end
