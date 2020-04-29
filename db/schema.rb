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

ActiveRecord::Schema.define(version: 20200429114057) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"

  create_table "access_tokens", force: :cascade do |t|
    t.string  "access_token"
    t.string  "refresh_token"
    t.integer "expires_at"
  end

  create_table "addresses", force: :cascade do |t|
    t.string   "postal_number"
    t.string   "city"
    t.string   "county"
    t.string   "postcode"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "building_name"
    t.string   "road_name"
    t.datetime "deleted_at"
    t.string   "addressable_type"
    t.integer  "addressable_id"
    t.string   "locality"
    t.string   "prefix"
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id", using: :btree
    t.index ["deleted_at"], name: "index_addresses_on_deleted_at", using: :btree
  end

  create_table "admin_notifications", force: :cascade do |t|
    t.string   "subject"
    t.text     "message"
    t.datetime "sent_at"
    t.integer  "author_id"
    t.integer  "sender_id"
    t.datetime "created_at",                   null: false
    t.boolean  "send_to_all",  default: false
    t.datetime "updated_at",                   null: false
    t.string   "send_to_type"
    t.integer  "send_to_id"
    t.index ["author_id"], name: "index_admin_notifications_on_author_id", using: :btree
    t.index ["send_to_type", "send_to_id"], name: "index_admin_notifications_on_send_to_type_and_send_to_id", using: :btree
    t.index ["sender_id"], name: "index_admin_notifications_on_sender_id", using: :btree
  end

  create_table "appliance_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "developer_id"
  end

  create_table "appliance_manufacturers", force: :cascade do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.string   "link"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "developer_id"
    t.index "lower((name)::text) varchar_pattern_ops", name: "search_index_on_appliance_manufacturer_name", using: :btree
  end

  create_table "appliances", force: :cascade do |t|
    t.string   "primary_image"
    t.string   "manual"
    t.string   "service_log"
    t.string   "warranty_num"
    t.integer  "warranty_length"
    t.string   "model_num"
    t.integer  "e_rating"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "deleted_at"
    t.string   "description"
    t.string   "secondary_image"
    t.string   "document"
    t.integer  "appliance_category_id"
    t.string   "guide"
    t.integer  "appliance_manufacturer_id"
    t.integer  "developer_id"
    t.index "lower((model_num)::text) varchar_pattern_ops", name: "search_index_on_appliance_model_num", using: :btree
    t.index ["appliance_category_id"], name: "index_appliances_on_appliance_category_id", using: :btree
    t.index ["appliance_manufacturer_id"], name: "index_appliances_on_appliance_manufacturer_id", using: :btree
    t.index ["deleted_at"], name: "index_appliances_on_deleted_at", using: :btree
  end

  create_table "appliances_rooms", force: :cascade do |t|
    t.integer  "appliance_id", null: false
    t.integer  "room_id",      null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["appliance_id", "room_id"], name: "appliance_room_index", using: :btree
    t.index ["room_id", "appliance_id"], name: "room_appliance_index", using: :btree
  end

  create_table "branded_apps", force: :cascade do |t|
    t.string  "app_owner_type"
    t.integer "app_owner_id"
    t.string  "android_link"
    t.string  "apple_link"
    t.string  "app_icon"
    t.index ["app_owner_type", "app_owner_id"], name: "index_branded_apps_on_app_owner_type_and_app_owner_id", using: :btree
  end

  create_table "branded_perks", force: :cascade do |t|
    t.integer "developer_id"
    t.string  "link"
    t.string  "account_number"
    t.string  "tile_image"
    t.index ["developer_id"], name: "index_branded_perks_on_developer_id", using: :btree
  end

  create_table "brands", force: :cascade do |t|
    t.string   "logo"
    t.string   "banner"
    t.string   "bg_color"
    t.string   "text_color"
    t.string   "content_bg_color"
    t.string   "content_text_color"
    t.string   "button_color"
    t.string   "button_text_color"
    t.datetime "deleted_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "brandable_type"
    t.integer  "brandable_id"
    t.string   "header_color"
    t.string   "login_image"
    t.string   "topnav_text"
    t.string   "topnav_text_color"
    t.string   "login_box_left_color"
    t.string   "login_box_right_color"
    t.string   "login_button_static_color"
    t.string   "login_button_hover_color"
    t.string   "content_box_color"
    t.string   "content_box_outline_color"
    t.string   "text_left_color"
    t.string   "text_right_color"
    t.string   "login_logo"
    t.string   "content_box_text"
    t.string   "heading_one"
    t.string   "heading_two"
    t.string   "info_text"
    t.string   "email_logo"
    t.index ["brandable_type", "brandable_id"], name: "index_brands_on_brandable_type_and_brandable_id", using: :btree
  end

  create_table "choice_configurations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "development_id"
    t.boolean  "archived",       default: false
    t.index ["development_id"], name: "index_choice_configurations_on_development_id", using: :btree
  end

  create_table "choices", force: :cascade do |t|
    t.string   "choiceable_type"
    t.integer  "choiceable_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "room_item_id"
    t.boolean  "archived",        default: false
    t.index ["choiceable_type", "choiceable_id"], name: "index_choices_on_choiceable_type_and_choiceable_id", using: :btree
    t.index ["room_item_id"], name: "index_choices_on_room_item_id", using: :btree
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type", using: :btree
  end

  create_table "clients", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.index ["email"], name: "index_clients_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true, using: :btree
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "title"
    t.string   "position"
    t.integer  "category"
    t.string   "email"
    t.string   "phone"
    t.string   "mobile"
    t.datetime "deleted_at"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "picture"
    t.string   "contactable_type"
    t.integer  "contactable_id"
    t.string   "organisation"
    t.boolean  "pinned",           default: false
    t.index "lower((\"position\")::text) varchar_pattern_ops", name: "search_index_on_contact_position", using: :btree
    t.index "lower((first_name)::text) varchar_pattern_ops", name: "search_index_on_contact_first_name", using: :btree
    t.index "lower((last_name)::text) varchar_pattern_ops", name: "search_index_on_contact_last_name", using: :btree
    t.index ["contactable_type", "contactable_id"], name: "index_contacts_on_contactable_type_and_contactable_id", using: :btree
    t.index ["deleted_at"], name: "index_contacts_on_deleted_at", using: :btree
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "default_faqs", force: :cascade do |t|
    t.text     "question"
    t.text     "answer"
    t.string   "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer  "country_id", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "developers", force: :cascade do |t|
    t.string   "company_name"
    t.string   "email"
    t.string   "contact_number"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.datetime "deleted_at"
    t.text     "about"
    t.string   "api_key"
    t.string   "list_id"
    t.boolean  "house_search"
    t.boolean  "enable_services",             default: false
    t.boolean  "enable_development_messages", default: false
    t.boolean  "development_faqs",            default: false
    t.boolean  "enable_roomsketcher",         default: true
    t.integer  "country_id",                                  null: false
    t.boolean  "enable_referrals",            default: false
    t.boolean  "enable_perks",                default: false
    t.boolean  "cas",                         default: false
    t.index ["company_name"], name: "index_developers_on_company_name", unique: true, where: "(deleted_at IS NULL)", using: :btree
    t.index ["deleted_at"], name: "index_developers_on_deleted_at", using: :btree
  end

  create_table "development_messages", force: :cascade do |t|
    t.string   "subject"
    t.string   "content"
    t.integer  "parent_id"
    t.integer  "development_id"
    t.integer  "resident_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["development_id"], name: "index_development_messages_on_development_id", using: :btree
    t.index ["parent_id"], name: "index_development_messages_on_parent_id", using: :btree
    t.index ["resident_id"], name: "index_development_messages_on_resident_id", using: :btree
  end

  create_table "developments", force: :cascade do |t|
    t.string   "name"
    t.integer  "developer_id"
    t.string   "email"
    t.string   "contact_number"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "division_id"
    t.datetime "deleted_at"
    t.integer  "phases_count",          default: 0
    t.string   "segment_id"
    t.boolean  "enable_snagging",       default: false
    t.integer  "snag_duration",         default: 0
    t.string   "snag_name",             default: "Snagging", null: false
    t.integer  "choice_option",         default: 0,          null: false
    t.string   "choices_email_contact"
    t.integer  "construction",          default: 0,          null: false
    t.string   "construction_name"
    t.boolean  "cas",                   default: false
    t.index ["deleted_at"], name: "index_developments_on_deleted_at", using: :btree
    t.index ["developer_id"], name: "index_developments_on_developer_id", using: :btree
    t.index ["division_id"], name: "index_developments_on_division_id", using: :btree
    t.index ["name", "developer_id", "division_id"], name: "index_developments_on_name_and_developer_id_and_division_id", unique: true, where: "(deleted_at IS NULL)", using: :btree
  end

  create_table "divisions", force: :cascade do |t|
    t.string   "division_name"
    t.string   "email"
    t.string   "contact_number"
    t.integer  "developer_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "list_id"
    t.index ["created_at"], name: "index_divisions_on_created_at", using: :btree
    t.index ["deleted_at"], name: "index_divisions_on_deleted_at", using: :btree
    t.index ["developer_id"], name: "index_divisions_on_developer_id", using: :btree
    t.index ["division_name", "developer_id"], name: "index_divisions_on_division_name_and_developer_id", unique: true, where: "(deleted_at IS NULL)", using: :btree
    t.index ["updated_at"], name: "index_divisions_on_updated_at", using: :btree
  end

  create_table "documents", force: :cascade do |t|
    t.string   "title"
    t.string   "documentable_type"
    t.integer  "documentable_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "file"
    t.string   "original_filename"
    t.integer  "category"
    t.string   "file_tmp"
    t.integer  "user_id"
    t.boolean  "pinned",            default: false
    t.index "lower((title)::text) varchar_pattern_ops", name: "search_index_on_document_title", using: :btree
    t.index ["documentable_type", "documentable_id"], name: "index_documents_on_documentable_type_and_documentable_id", using: :btree
    t.index ["user_id"], name: "index_documents_on_user_id", using: :btree
  end

  create_table "documents_plots", force: :cascade do |t|
    t.integer  "document_id",                        null: false
    t.integer  "plot_id",                            null: false
    t.boolean  "enable_tenant_read", default: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["document_id", "plot_id"], name: "document_plot_index", using: :btree
    t.index ["plot_id", "document_id"], name: "plot_document_index", using: :btree
  end

  create_table "faqs", force: :cascade do |t|
    t.text     "question"
    t.text     "answer"
    t.integer  "category"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "faqable_type"
    t.integer  "faqable_id"
    t.index "lower(question) varchar_pattern_ops", name: "search_index_on_faq_question", using: :btree
    t.index ["faqable_type", "faqable_id"], name: "index_faqs_on_faqable_type_and_faqable_id", using: :btree
  end

  create_table "finish_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "developer_id"
  end

  create_table "finish_categories_types", id: false, force: :cascade do |t|
    t.integer  "finish_category_id", null: false
    t.integer  "finish_type_id",     null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["finish_category_id", "finish_type_id"], name: "finish_category_finish_type_index", using: :btree
    t.index ["finish_type_id", "finish_category_id"], name: "finish_type_finish_category_index", using: :btree
  end

  create_table "finish_manufacturers", force: :cascade do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "developer_id"
    t.index "lower((name)::text) varchar_pattern_ops", name: "search_index_on_finish_manufacturer_name", using: :btree
  end

  create_table "finish_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "developer_id"
    t.index "lower((name)::text) varchar_pattern_ops", name: "search_index_on_finish_type_name", using: :btree
  end

  create_table "finish_types_manufacturers", id: false, force: :cascade do |t|
    t.integer  "finish_type_id",         null: false
    t.integer  "manufacturer_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "finish_manufacturer_id"
    t.index ["finish_manufacturer_id"], name: "index_finish_types_manufacturers_on_finish_manufacturer_id", using: :btree
    t.index ["finish_type_id"], name: "index_finish_types_manufacturers_on_finish_type_id", using: :btree
  end

  create_table "finishes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "picture"
    t.datetime "deleted_at"
    t.string   "description"
    t.integer  "finish_category_id"
    t.integer  "finish_type_id"
    t.integer  "finish_manufacturer_id"
    t.string   "original_filename"
    t.integer  "developer_id"
    t.index "lower((name)::text) varchar_pattern_ops", name: "search_index_on_finish_name", using: :btree
    t.index ["deleted_at"], name: "index_finishes_on_deleted_at", using: :btree
    t.index ["finish_category_id"], name: "index_finishes_on_finish_category_id", using: :btree
    t.index ["finish_manufacturer_id"], name: "index_finishes_on_finish_manufacturer_id", using: :btree
    t.index ["finish_type_id"], name: "index_finishes_on_finish_type_id", using: :btree
    t.index ["name", "finish_category_id", "finish_type_id", "finish_manufacturer_id", "developer_id"], name: "index_finishes_on_combo", unique: true, using: :btree
  end

  create_table "finishes_rooms", force: :cascade do |t|
    t.integer  "finish_id",  null: false
    t.integer  "room_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["finish_id", "room_id"], name: "finish_room_index", using: :btree
    t.index ["room_id", "finish_id"], name: "room_finish_index", using: :btree
  end

  create_table "how_to_sub_categories", force: :cascade do |t|
    t.text     "name"
    t.text     "parent_category"
    t.datetime "deleted_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "how_tos", force: :cascade do |t|
    t.text     "title"
    t.text     "summary"
    t.text     "description"
    t.integer  "category"
    t.integer  "featured"
    t.string   "picture"
    t.datetime "deleted_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "url"
    t.string   "additional_text"
    t.integer  "how_to_sub_category_id"
    t.boolean  "hide",                   default: false
    t.integer  "country_id",                             null: false
    t.index "lower(summary) varchar_pattern_ops", name: "search_index_on_how_to_summary", using: :btree
    t.index "lower(title) varchar_pattern_ops", name: "search_index_on_how_to_title", using: :btree
    t.index ["how_to_sub_category_id"], name: "index_how_tos_on_how_to_sub_category_id", using: :btree
  end

  create_table "how_tos_tags", id: false, force: :cascade do |t|
    t.integer  "how_to_id",  null: false
    t.integer  "tag_id",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["how_to_id", "tag_id"], name: "how_to_tag_index", using: :btree
    t.index ["tag_id", "how_to_id"], name: "tag_how_to_index", using: :btree
  end

  create_table "lettings_accounts", force: :cascade do |t|
    t.string  "reference"
    t.integer "access_token_id"
    t.integer "authorisation_status", default: 0
    t.integer "management",           default: 0
    t.string  "accountable_type"
    t.integer "accountable_id"
    t.index ["access_token_id"], name: "index_lettings_accounts_on_access_token_id", using: :btree
    t.index ["accountable_type", "accountable_id"], name: "index_lettings_accounts_on_accountable_type_and_accountable_id", using: :btree
  end

  create_table "listings", force: :cascade do |t|
    t.string  "reference"
    t.string  "other_ref"
    t.integer "owner",               null: false
    t.integer "lettings_account_id"
    t.integer "plot_id",             null: false
    t.index ["lettings_account_id"], name: "index_listings_on_lettings_account_id", using: :btree
    t.index ["plot_id"], name: "index_listings_on_plot_id", unique: true, using: :btree
  end

  create_table "logs", force: :cascade do |t|
    t.string   "logable_type"
    t.integer  "logable_id"
    t.string   "primary"
    t.string   "secondary"
    t.integer  "action"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["logable_type", "logable_id"], name: "index_logs_on_logable_type_and_logable_id", using: :btree
  end

  create_table "maintenances", force: :cascade do |t|
    t.integer "development_id"
    t.string  "path"
    t.integer "account_type"
    t.boolean "populate",       default: true
    t.index ["development_id"], name: "index_maintenances_on_development_id", using: :btree
  end

  create_table "marks", force: :cascade do |t|
    t.string  "markable_type"
    t.integer "markable_id"
    t.string  "username"
    t.integer "role"
    t.index ["markable_type", "markable_id"], name: "index_marks_on_markable_type_and_markable_id", using: :btree
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "subject"
    t.text     "message"
    t.datetime "sent_at"
    t.integer  "author_id"
    t.integer  "sender_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "send_to_type"
    t.integer  "send_to_id"
    t.boolean  "send_to_all",  default: false
    t.string   "plot_numbers",                              array: true
    t.string   "plot_prefix"
    t.integer  "send_to_role"
    t.index "lower((subject)::text) varchar_pattern_ops", name: "search_index_on_notification_subject", using: :btree
    t.index ["author_id"], name: "index_notifications_on_author_id", using: :btree
    t.index ["send_to_type", "send_to_id"], name: "index_notifications_on_send_to_type_and_send_to_id", using: :btree
    t.index ["sender_id"], name: "index_notifications_on_sender_id", using: :btree
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.string   "searchable_type"
    t.integer  "searchable_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id", using: :btree
  end

  create_table "phases", force: :cascade do |t|
    t.string   "name"
    t.integer  "development_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "developer_id"
    t.integer  "division_id"
    t.integer  "number"
    t.datetime "deleted_at"
    t.integer  "total_snags",      default: 0
    t.integer  "unresolved_snags", default: 0
    t.integer  "business",         default: 0
    t.index ["deleted_at"], name: "index_phases_on_deleted_at", using: :btree
    t.index ["developer_id"], name: "index_phases_on_developer_id", using: :btree
    t.index ["development_id"], name: "index_phases_on_development_id", using: :btree
    t.index ["division_id"], name: "index_phases_on_division_id", using: :btree
    t.index ["name", "development_id"], name: "index_phases_on_name_and_development_id", unique: true, where: "(deleted_at IS NULL)", using: :btree
  end

  create_table "plot_residencies", force: :cascade do |t|
    t.integer  "plot_id"
    t.integer  "resident_id"
    t.date     "completion_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "role"
    t.string   "invited_by_type"
    t.integer  "invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_plot_residencies_on_invited_by_type_and_invited_by_id", using: :btree
    t.index ["plot_id"], name: "index_plot_residencies_on_plot_id", using: :btree
    t.index ["resident_id"], name: "index_plot_residencies_on_resident_id", using: :btree
  end

  create_table "plots", force: :cascade do |t|
    t.string   "number"
    t.integer  "unit_type_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "developer_id"
    t.integer  "division_id"
    t.integer  "development_id"
    t.datetime "deleted_at"
    t.integer  "phase_id"
    t.string   "house_number"
    t.integer  "progress",                 default: 0
    t.date     "completion_date"
    t.date     "completion_release_date"
    t.date     "reservation_release_date"
    t.integer  "validity",                 default: 27
    t.integer  "extended_access",          default: 0
    t.integer  "total_snags",              default: 0
    t.integer  "unresolved_snags",         default: 0
    t.integer  "choice_configuration_id"
    t.integer  "choice_selection_status",  default: 0,  null: false
    t.string   "completion_order_number"
    t.string   "reservation_order_number"
    t.index ["deleted_at"], name: "index_plots_on_deleted_at", using: :btree
    t.index ["developer_id"], name: "index_plots_on_developer_id", using: :btree
    t.index ["development_id"], name: "index_plots_on_development_id", using: :btree
    t.index ["division_id"], name: "index_plots_on_division_id", using: :btree
    t.index ["phase_id"], name: "index_plots_on_phase_id", using: :btree
    t.index ["unit_type_id"], name: "index_plots_on_unit_type_id", using: :btree
  end

  create_table "plots_private_documents", force: :cascade do |t|
    t.integer  "private_document_id",                 null: false
    t.integer  "plot_id",                             null: false
    t.boolean  "enable_tenant_read",  default: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["plot_id", "private_document_id"], name: "plot_private_document_index", using: :btree
    t.index ["private_document_id", "plot_id"], name: "private_document_plot_index", using: :btree
  end

  create_table "premium_perks", force: :cascade do |t|
    t.integer  "development_id"
    t.boolean  "enable_premium_perks",     default: false
    t.integer  "premium_licences_bought"
    t.integer  "premium_licence_duration"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "sign_up_count",            default: 0
    t.index ["development_id"], name: "index_premium_perks_on_development_id", using: :btree
  end

  create_table "private_documents", force: :cascade do |t|
    t.string   "title"
    t.string   "file"
    t.integer  "resident_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "plot_id"
    t.index ["plot_id"], name: "index_private_documents_on_plot_id", using: :btree
    t.index ["resident_id"], name: "index_private_documents_on_resident_id", using: :btree
  end

  create_table "referrals", force: :cascade do |t|
    t.string   "referrer_name"
    t.string   "referrer_email"
    t.string   "referrer_developer"
    t.string   "referrer_address"
    t.string   "referee_first_name"
    t.string   "referee_last_name"
    t.string   "referee_email"
    t.string   "referee_phone"
    t.datetime "referral_date"
    t.boolean  "email_confirmed",    default: false
    t.string   "confirm_token"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "resident_notifications", force: :cascade do |t|
    t.integer  "resident_id"
    t.integer  "notification_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.datetime "read_at"
    t.index ["notification_id"], name: "index_resident_notifications_on_notification_id", using: :btree
    t.index ["resident_id"], name: "index_resident_notifications_on_resident_id", using: :btree
  end

  create_table "residents", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                   default: "", null: false
    t.string   "encrypted_password",      default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.datetime "deleted_at"
    t.integer  "title",                   default: 0
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.string   "invited_by_type"
    t.integer  "invited_by_id"
    t.integer  "invitations_count",       default: 0
    t.integer  "developer_email_updates"
    t.integer  "cf_email_updates"
    t.integer  "telephone_updates"
    t.string   "phone_number"
    t.datetime "ts_and_cs_accepted_at"
    t.index ["email"], name: "index_residents_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_residents_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_residents_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_residents_on_invited_by_id", using: :btree
    t.index ["invited_by_type"], name: "index_residents_on_invited_by_type", using: :btree
    t.index ["reset_password_token"], name: "index_residents_on_reset_password_token", unique: true, using: :btree
  end

  create_table "room_choices", force: :cascade do |t|
    t.integer "plot_id"
    t.integer "room_item_id"
    t.integer "choice_id"
    t.index ["choice_id"], name: "index_room_choices_on_choice_id", using: :btree
    t.index ["plot_id"], name: "index_room_choices_on_plot_id", using: :btree
    t.index ["room_item_id"], name: "index_room_choices_on_room_item_id", using: :btree
  end

  create_table "room_configurations", force: :cascade do |t|
    t.string   "name"
    t.integer  "icon_name"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "choice_configuration_id"
    t.index ["choice_configuration_id"], name: "index_room_configurations_on_choice_configuration_id", using: :btree
  end

  create_table "room_items", force: :cascade do |t|
    t.string   "name"
    t.string   "room_itemable_type"
    t.integer  "room_itemable_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "room_configuration_id"
    t.index ["room_configuration_id"], name: "index_room_items_on_room_configuration_id", using: :btree
    t.index ["room_itemable_type", "room_itemable_id"], name: "index_room_items_on_room_itemable_type_and_room_itemable_id", using: :btree
  end

  create_table "rooms", force: :cascade do |t|
    t.string   "name"
    t.integer  "unit_type_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "developer_id"
    t.integer  "division_id"
    t.integer  "development_id"
    t.datetime "deleted_at"
    t.integer  "icon_name"
    t.integer  "plot_id"
    t.integer  "template_room_id"
    t.index "lower((name)::text) varchar_pattern_ops", name: "search_index_on_room_name", using: :btree
    t.index ["deleted_at"], name: "index_rooms_on_deleted_at", using: :btree
    t.index ["developer_id"], name: "index_rooms_on_developer_id", using: :btree
    t.index ["development_id"], name: "index_rooms_on_development_id", using: :btree
    t.index ["division_id"], name: "index_rooms_on_division_id", using: :btree
    t.index ["name", "unit_type_id"], name: "index_rooms_on_name_and_unit_type_id", unique: true, where: "(deleted_at IS NULL)", using: :btree
    t.index ["plot_id"], name: "index_rooms_on_plot_id", using: :btree
    t.index ["unit_type_id"], name: "index_rooms_on_unit_type_id", using: :btree
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "settings", force: :cascade do |t|
    t.string   "video_link"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "cookie_policy"
    t.string   "cookie_short_name"
    t.string   "privacy_policy"
    t.string   "privacy_short_name"
    t.string   "help"
    t.string   "help_short_name"
    t.boolean  "intro_video_enabled", default: true
  end

  create_table "snag_attachments", force: :cascade do |t|
    t.integer  "snag_id"
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "snag_comments", force: :cascade do |t|
    t.string   "content"
    t.string   "image"
    t.integer  "snag_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "commenter_type"
    t.integer  "commenter_id"
    t.index ["commenter_type", "commenter_id"], name: "index_snag_comments_on_commenter_type_and_commenter_id", using: :btree
    t.index ["snag_id"], name: "index_snag_comments_on_snag_id", using: :btree
  end

  create_table "snags", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "plot_id"
    t.integer  "status",      default: 0
    t.index ["plot_id"], name: "index_snags_on_plot_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.text     "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unit_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "deleted_at"
    t.integer  "developer_id"
    t.integer  "division_id"
    t.integer  "development_id"
    t.integer  "build_type",     default: 0
    t.string   "picture"
    t.string   "external_link"
    t.boolean  "restricted",     default: false
    t.index ["developer_id"], name: "index_unit_types_on_developer_id", using: :btree
    t.index ["development_id"], name: "index_unit_types_on_development_id", using: :btree
    t.index ["division_id"], name: "index_unit_types_on_division_id", using: :btree
    t.index ["name", "development_id"], name: "index_unit_types_on_name_and_development_id", unique: true, where: "(deleted_at IS NULL)", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "role"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.string   "invited_by_type"
    t.integer  "invited_by_id"
    t.integer  "invitations_count",      default: 0
    t.datetime "deleted_at"
    t.string   "permission_level_type"
    t.integer  "permission_level_id"
    t.string   "picture"
    t.string   "job_title"
    t.boolean  "receive_release_emails", default: true
    t.boolean  "snag_notifications",     default: true
    t.boolean  "receive_choice_emails",  default: false
    t.integer  "lettings_management",    default: 0
    t.boolean  "cas",                    default: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
    t.index ["invited_by_type"], name: "index_users_on_invited_by_type", using: :btree
    t.index ["permission_level_type", "permission_level_id"], name: "index_users_on_permission_level_type_and_permission_level_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "videos", force: :cascade do |t|
    t.string   "title"
    t.string   "link"
    t.string   "videoable_type"
    t.integer  "videoable_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["videoable_type", "videoable_id"], name: "index_videos_on_videoable_type_and_videoable_id", using: :btree
  end

  add_foreign_key "appliance_categories", "developers"
  add_foreign_key "appliance_manufacturers", "developers"
  add_foreign_key "appliances", "appliance_categories"
  add_foreign_key "appliances", "appliance_manufacturers"
  add_foreign_key "appliances", "developers"
  add_foreign_key "branded_perks", "developers"
  add_foreign_key "development_messages", "developments"
  add_foreign_key "development_messages", "residents"
  add_foreign_key "developments", "developers"
  add_foreign_key "developments", "divisions"
  add_foreign_key "divisions", "developers"
  add_foreign_key "documents", "users"
  add_foreign_key "finish_categories", "developers"
  add_foreign_key "finish_manufacturers", "developers"
  add_foreign_key "finish_types", "developers"
  add_foreign_key "finish_types_manufacturers", "finish_manufacturers"
  add_foreign_key "finishes", "developers"
  add_foreign_key "finishes", "finish_categories"
  add_foreign_key "finishes", "finish_manufacturers"
  add_foreign_key "finishes", "finish_types"
  add_foreign_key "how_tos", "how_to_sub_categories"
  add_foreign_key "maintenances", "developments"
  add_foreign_key "phases", "developers"
  add_foreign_key "phases", "developments"
  add_foreign_key "phases", "divisions"
  add_foreign_key "plot_residencies", "plots"
  add_foreign_key "plot_residencies", "residents"
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
  add_foreign_key "unit_types", "developers"
  add_foreign_key "unit_types", "developments"
  add_foreign_key "unit_types", "divisions"
end
