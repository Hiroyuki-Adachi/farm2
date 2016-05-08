# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160507103100) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chemical_kinds", force: :cascade do |t|
    t.integer "chemical_type_id", null: false
    t.integer "work_kind_id",     null: false
  end

  add_index "chemical_kinds", ["chemical_type_id", "work_kind_id"], name: "index_chemical_kinds_on_chemical_type_id_and_work_kind_id", unique: true, using: :btree

  create_table "chemical_types", force: :cascade do |t|
    t.string   "name",          limit: 20,             null: false
    t.integer  "display_order",            default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chemicals", force: :cascade do |t|
    t.string   "name",             limit: 20,             null: false
    t.integer  "display_order",               default: 0, null: false
    t.integer  "chemical_type_id",                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "chemicals", ["deleted_at"], name: "index_chemicals_on_deleted_at", using: :btree

  create_table "homes", force: :cascade do |t|
    t.string   "phonetic",      limit: 15
    t.string   "name",          limit: 10
    t.integer  "worker_id"
    t.string   "zip_code",      limit: 7
    t.string   "address1",      limit: 50
    t.string   "address2",      limit: 50
    t.string   "telephone",     limit: 15
    t.string   "fax",           limit: 15
    t.integer  "section_id"
    t.integer  "display_order"
    t.boolean  "member_flag",              default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "homes", ["deleted_at"], name: "index_homes_on_deleted_at", using: :btree

  create_table "lands", force: :cascade do |t|
    t.string   "place",         limit: 15,                                        null: false
    t.integer  "home_id"
    t.decimal  "area",                     precision: 5, scale: 2,                null: false
    t.integer  "display_order"
    t.boolean  "target_flag",                                      default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "lands", ["deleted_at"], name: "index_lands_on_deleted_at", using: :btree

  create_table "machine_results", force: :cascade do |t|
    t.integer  "machine_id"
    t.integer  "work_result_id"
    t.integer  "display_order",                          default: 1,   null: false
    t.decimal  "hours",          precision: 3, scale: 1, default: 0.0, null: false
    t.decimal  "areas",          precision: 6, scale: 2, default: 0.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "machine_results", ["machine_id", "work_result_id"], name: "index_machine_results_on_machine_id_and_work_result_id", unique: true, using: :btree

  create_table "machine_type_prices", force: :cascade do |t|
    t.integer "machine_type_id"
    t.integer "term"
    t.decimal "price_per_day",   precision: 6, default: 0, null: false
    t.decimal "price_per_area",  precision: 6, default: 0, null: false
    t.decimal "price_per_hour",  precision: 6, default: 0, null: false
  end

  add_index "machine_type_prices", ["machine_type_id", "term"], name: "index_machine_type_prices_on_machine_type_id_and_term", unique: true, using: :btree

  create_table "machine_types", force: :cascade do |t|
    t.string   "name",                limit: 10,                 null: false
    t.integer  "display_order",                  default: 1,     null: false
    t.integer  "rental_pay_mode",                default: 0,     null: false
    t.boolean  "rental_by_work_type",            default: false, null: false
    t.integer  "lease_pay_mode",                 default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "machines", force: :cascade do |t|
    t.string   "name",              limit: 40,             null: false
    t.integer  "display_order",                            null: false
    t.date     "validity_start_at"
    t.date     "validity_end_at"
    t.integer  "machine_type_id",              default: 0, null: false
    t.integer  "home_id",                      default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "show_work1",    limit: 10,              null: false
    t.string   "show_work2",    limit: 10,              null: false
    t.integer  "workers_count", limit: 2,  default: 12, null: false
    t.integer  "lands_count",   limit: 2,  default: 12, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", force: :cascade do |t|
    t.string   "name",          limit: 40,                null: false
    t.integer  "display_order",            default: 1,    null: false
    t.boolean  "work_flag",                default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "sections", ["deleted_at"], name: "index_sections_on_deleted_at", using: :btree

  create_table "systems", force: :cascade do |t|
    t.date     "target_from"
    t.date     "target_to"
    t.integer  "term"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tests", force: :cascade do |t|
    t.string   "name"
    t.decimal  "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "work_chemicals", force: :cascade do |t|
    t.integer  "work_id",                               null: false
    t.integer  "chemical_id",                           null: false
    t.decimal  "quantity",    precision: 3, default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "work_chemicals", ["work_id", "chemical_id"], name: "index_work_chemicals_on_work_id_and_chemical_id", unique: true, using: :btree

  create_table "work_kinds", force: :cascade do |t|
    t.string   "name",          limit: 20,                               null: false
    t.integer  "display_order",                                          null: false
    t.decimal  "price",                    precision: 4, default: 1000,  null: false
    t.boolean  "other_flag",                             default: false, null: false
    t.integer  "work_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "work_kinds", ["deleted_at"], name: "index_work_kinds_on_deleted_at", using: :btree

  create_table "work_lands", force: :cascade do |t|
    t.integer  "work_id"
    t.integer  "land_id"
    t.integer  "display_order", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "work_lands", ["work_id", "land_id"], name: "index_work_lands_on_work_id_and_land_id", unique: true, using: :btree

  create_table "work_results", force: :cascade do |t|
    t.integer  "work_id"
    t.integer  "worker_id"
    t.decimal  "hours",         precision: 3, scale: 1, default: 0.0, null: false
    t.integer  "display_order",                         default: 0,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "work_results", ["work_id", "worker_id"], name: "index_work_results_on_work_id_and_worker_id", unique: true, using: :btree

  create_table "work_types", force: :cascade do |t|
    t.integer  "genre",                                    null: false
    t.string   "name",          limit: 10,                 null: false
    t.boolean  "category_flag",            default: false
    t.integer  "display_order",            default: 0,     null: false
    t.datetime "deleted_at"
  end

  add_index "work_types", ["deleted_at"], name: "index_work_types_on_deleted_at", using: :btree

  create_table "workers", force: :cascade do |t|
    t.string   "family_phonetic", limit: 15,                null: false
    t.string   "family_name",     limit: 10,                null: false
    t.string   "first_phonetic",  limit: 15,                null: false
    t.string   "first_name",      limit: 10,                null: false
    t.date     "birthday"
    t.integer  "home_id"
    t.string   "mobile",          limit: 15
    t.string   "mobile_mail",     limit: 50
    t.string   "pc_mail",         limit: 50
    t.integer  "display_order"
    t.boolean  "work_flag",                  default: true, null: false
    t.integer  "gender_type",     limit: 2,  default: 0,    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "workers", ["deleted_at"], name: "index_workers_on_deleted_at", using: :btree

  create_table "works", force: :cascade do |t|
    t.integer  "year",                                null: false
    t.date     "worked_at",                           null: false
    t.integer  "weather",      limit: 2,              null: false
    t.integer  "work_type_id"
    t.string   "name",         limit: 40,             null: false
    t.text     "remarks"
    t.datetime "start_at",                            null: false
    t.datetime "end_at",                              null: false
    t.date     "payed_at"
    t.integer  "work_kind_id",            default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
