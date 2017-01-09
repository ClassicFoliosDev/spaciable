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

ActiveRecord::Schema.define(version: 20170105142623) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "postal_name"
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
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id", using: :btree
    t.index ["deleted_at"], name: "index_addresses_on_deleted_at", using: :btree
  end

  create_table "appliances", force: :cascade do |t|
    t.string   "name"
    t.string   "primary_image"
    t.string   "images"
    t.string   "manual"
    t.integer  "manufacturer"
    t.string   "serial"
    t.integer  "category"
    t.string   "source"
    t.string   "service_log"
    t.string   "warranty_num"
    t.datetime "wwarranty_exp_date"
    t.integer  "warranty_length"
    t.string   "model_num"
    t.integer  "e_rating"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_appliances_on_deleted_at", using: :btree
  end

  create_table "developers", force: :cascade do |t|
    t.string   "company_name"
    t.string   "postal_name"
    t.string   "city"
    t.string   "county"
    t.string   "postcode"
    t.string   "email"
    t.string   "contact_number"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.datetime "deleted_at"
    t.text     "about"
    t.string   "building_name"
    t.string   "road_name"
    t.index ["deleted_at"], name: "index_developers_on_deleted_at", using: :btree
  end

  create_table "developments", force: :cascade do |t|
    t.string   "name"
    t.integer  "developer_id"
    t.string   "email"
    t.string   "contact_number"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "division_id"
    t.datetime "deleted_at"
    t.integer  "phases_count",   default: 0
    t.index ["deleted_at"], name: "index_developments_on_deleted_at", using: :btree
    t.index ["developer_id"], name: "index_developments_on_developer_id", using: :btree
    t.index ["division_id"], name: "index_developments_on_division_id", using: :btree
  end

  create_table "divisions", force: :cascade do |t|
    t.string   "division_name"
    t.string   "email"
    t.string   "contact_number"
    t.integer  "developer_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["created_at"], name: "index_divisions_on_created_at", using: :btree
    t.index ["deleted_at"], name: "index_divisions_on_deleted_at", using: :btree
    t.index ["developer_id"], name: "index_divisions_on_developer_id", using: :btree
    t.index ["updated_at"], name: "index_divisions_on_updated_at", using: :btree
  end

  create_table "documents", force: :cascade do |t|
    t.string   "title"
    t.string   "documentable_type"
    t.integer  "documentable_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "file"
    t.integer  "developer_id"
    t.integer  "division_id"
    t.integer  "development_id"
    t.index ["developer_id"], name: "index_documents_on_developer_id", using: :btree
    t.index ["development_id"], name: "index_documents_on_development_id", using: :btree
    t.index ["division_id"], name: "index_documents_on_division_id", using: :btree
    t.index ["documentable_type", "documentable_id"], name: "index_documents_on_documentable_type_and_documentable_id", using: :btree
  end

  create_table "finish_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "finish_categories_types", id: false, force: :cascade do |t|
    t.integer  "finish_category_id", null: false
    t.integer  "finish_type_id",     null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["finish_category_id", "finish_type_id"], name: "finish_category_finish_type_index", using: :btree
    t.index ["finish_type_id", "finish_category_id"], name: "finish_type_finish_category_index", using: :btree
  end

  create_table "finish_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "finish_types_manufacturers", id: false, force: :cascade do |t|
    t.integer  "finish_type_id",  null: false
    t.integer  "manufacturer_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["finish_type_id", "manufacturer_id"], name: "finish_type_manufacturers_index", using: :btree
    t.index ["manufacturer_id", "finish_type_id"], name: "manufacturer_finish_type_index", using: :btree
  end

  create_table "finishes", force: :cascade do |t|
    t.integer  "room_id"
    t.string   "name"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "picture"
    t.integer  "developer_id"
    t.integer  "division_id"
    t.integer  "development_id"
    t.datetime "deleted_at"
    t.integer  "type"
    t.string   "description"
    t.integer  "finish_category_id"
    t.integer  "finish_type_id"
    t.integer  "manufacturer_id"
    t.integer  "cat_list"
    t.index ["deleted_at"], name: "index_finishes_on_deleted_at", using: :btree
    t.index ["developer_id"], name: "index_finishes_on_developer_id", using: :btree
    t.index ["development_id"], name: "index_finishes_on_development_id", using: :btree
    t.index ["division_id"], name: "index_finishes_on_division_id", using: :btree
    t.index ["finish_category_id"], name: "index_finishes_on_finish_category_id", using: :btree
    t.index ["finish_type_id"], name: "index_finishes_on_finish_type_id", using: :btree
    t.index ["manufacturer_id"], name: "index_finishes_on_manufacturer_id", using: :btree
    t.index ["room_id"], name: "index_finishes_on_room_id", using: :btree
  end

  create_table "homeowner_login_contents", force: :cascade do |t|
    t.string   "title_left"
    t.string   "title_right"
    t.text     "blurb_para_1"
    t.text     "blurb_para_2"
    t.string   "background_image"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "images", force: :cascade do |t|
    t.string  "title"
    t.string  "imageable_type"
    t.integer "imageable_id"
    t.string  "file"
    t.integer "developer_id"
    t.integer "division_id"
    t.integer "development_id"
    t.index ["developer_id"], name: "index_images_on_developer_id", using: :btree
    t.index ["development_id"], name: "index_images_on_development_id", using: :btree
    t.index ["division_id"], name: "index_images_on_division_id", using: :btree
    t.index ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id", using: :btree
  end

  create_table "manufacturers", force: :cascade do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "phases", force: :cascade do |t|
    t.string   "name"
    t.integer  "development_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "developer_id"
    t.integer  "division_id"
    t.integer  "number"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_phases_on_deleted_at", using: :btree
    t.index ["developer_id"], name: "index_phases_on_developer_id", using: :btree
    t.index ["development_id"], name: "index_phases_on_development_id", using: :btree
    t.index ["division_id"], name: "index_phases_on_division_id", using: :btree
  end

  create_table "phases_unit_types", id: false, force: :cascade do |t|
    t.integer "phase_id",     null: false
    t.integer "unit_type_id", null: false
    t.index ["phase_id", "unit_type_id"], name: "index_phases_unit_types_on_phase_id_and_unit_type_id", using: :btree
    t.index ["unit_type_id", "phase_id"], name: "index_phases_unit_types_on_unit_type_id_and_phase_id", using: :btree
  end

  create_table "plots", force: :cascade do |t|
    t.string   "prefix"
    t.decimal  "number"
    t.integer  "unit_type_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "developer_id"
    t.integer  "division_id"
    t.integer  "development_id"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_plots_on_deleted_at", using: :btree
    t.index ["developer_id"], name: "index_plots_on_developer_id", using: :btree
    t.index ["development_id"], name: "index_plots_on_development_id", using: :btree
    t.index ["division_id"], name: "index_plots_on_division_id", using: :btree
    t.index ["unit_type_id"], name: "index_plots_on_unit_type_id", using: :btree
  end

  create_table "plots_users", id: false, force: :cascade do |t|
    t.integer  "plot_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plot_id"], name: "index_plots_users_on_plot_id", using: :btree
    t.index ["user_id"], name: "index_plots_users_on_user_id", using: :btree
  end

  create_table "rooms", force: :cascade do |t|
    t.string   "name"
    t.integer  "unit_type_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "developer_id"
    t.integer  "division_id"
    t.integer  "development_id"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_rooms_on_deleted_at", using: :btree
    t.index ["developer_id"], name: "index_rooms_on_developer_id", using: :btree
    t.index ["development_id"], name: "index_rooms_on_development_id", using: :btree
    t.index ["division_id"], name: "index_rooms_on_division_id", using: :btree
    t.index ["unit_type_id"], name: "index_rooms_on_unit_type_id", using: :btree
  end

  create_table "unit_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "developer_id"
    t.integer  "division_id"
    t.integer  "development_id"
    t.integer  "build_type",     default: 0
    t.string   "picture"
    t.index ["developer_id"], name: "index_unit_types_on_developer_id", using: :btree
    t.index ["development_id"], name: "index_unit_types_on_development_id", using: :btree
    t.index ["division_id"], name: "index_unit_types_on_division_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "role"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
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
    t.integer  "developer_id"
    t.integer  "division_id"
    t.index ["developer_id"], name: "index_users_on_developer_id", using: :btree
    t.index ["division_id"], name: "index_users_on_division_id", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "developments", "developers"
  add_foreign_key "developments", "divisions"
  add_foreign_key "divisions", "developers"
  add_foreign_key "documents", "developers"
  add_foreign_key "documents", "developments"
  add_foreign_key "documents", "divisions"
  add_foreign_key "finishes", "developers"
  add_foreign_key "finishes", "developments"
  add_foreign_key "finishes", "divisions"
  add_foreign_key "finishes", "finish_categories"
  add_foreign_key "finishes", "finish_types"
  add_foreign_key "finishes", "manufacturers"
  add_foreign_key "finishes", "rooms"
  add_foreign_key "images", "developers"
  add_foreign_key "images", "developments"
  add_foreign_key "images", "divisions"
  add_foreign_key "phases", "developers"
  add_foreign_key "phases", "developments"
  add_foreign_key "phases", "divisions"
  add_foreign_key "plots", "developers"
  add_foreign_key "plots", "developments"
  add_foreign_key "plots", "divisions"
  add_foreign_key "plots", "unit_types"
  add_foreign_key "plots_users", "plots"
  add_foreign_key "plots_users", "users"
  add_foreign_key "rooms", "developers"
  add_foreign_key "rooms", "developments"
  add_foreign_key "rooms", "divisions"
  add_foreign_key "rooms", "unit_types"
  add_foreign_key "unit_types", "developers"
  add_foreign_key "unit_types", "developments"
  add_foreign_key "unit_types", "divisions"
  add_foreign_key "users", "developers"
  add_foreign_key "users", "divisions"
end
