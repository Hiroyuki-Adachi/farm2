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

ActiveRecord::Schema.define(version: 20160611101353) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bank_branches", id: false, force: :cascade, comment: "支店マスタ" do |t|
    t.string   "bank_code",  limit: 4,  null: false, comment: "金融機関コード"
    t.string   "code",       limit: 3,  null: false, comment: "支店コード"
    t.string   "name",       limit: 40, null: false, comment: "支店名称"
    t.string   "phonetic",   limit: 40, null: false, comment: "支店名称(ﾌﾘｶﾞﾅ)"
    t.string   "zip_code",   limit: 7,               comment: "郵便番号"
    t.string   "address1",   limit: 50,              comment: "住所1"
    t.string   "address2",   limit: 50,              comment: "住所2"
    t.string   "telephone",  limit: 15,              comment: "電話番号"
    t.string   "fax",        limit: 15,              comment: "FAX番号"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "banks", primary_key: "code", force: :cascade, comment: "金融機関マスタ" do |t|
    t.string   "name",       limit: 40, null: false, comment: "金融機関名称"
    t.string   "phonetic",   limit: 40, null: false, comment: "金融機関名称(ﾌﾘｶﾞﾅ)"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "chemical_kinds", force: :cascade, comment: "作業種別薬剤種別利用マスタ" do |t|
    t.integer "chemical_type_id", null: false, comment: "薬剤種別"
    t.integer "work_kind_id",     null: false, comment: "作業種別"
  end

  add_index "chemical_kinds", ["chemical_type_id", "work_kind_id"], name: "index_chemical_kinds_on_chemical_type_id_and_work_kind_id", unique: true, using: :btree

  create_table "chemical_terms", id: false, force: :cascade, comment: "薬剤年度別利用マスタ" do |t|
    t.integer "chemical_id", null: false, comment: "薬剤"
    t.integer "term",        null: false, comment: "年度(期)"
  end

  create_table "chemical_types", force: :cascade, comment: "薬剤種別マスタ" do |t|
    t.string   "name",          limit: 20,             null: false, comment: "薬剤種別名称"
    t.integer  "display_order",            default: 1, null: false, comment: "表示順"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chemicals", force: :cascade, comment: "薬剤マスタ" do |t|
    t.string   "name",             limit: 20,             null: false, comment: "薬剤名称"
    t.integer  "display_order",               default: 0, null: false, comment: "表示順"
    t.integer  "chemical_type_id",                        null: false, comment: "薬剤種別"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "chemicals", ["deleted_at"], name: "index_chemicals_on_deleted_at", using: :btree

  create_table "fixes", id: false, force: :cascade, comment: "確定データ" do |t|
    t.integer  "term",                          default: 0, null: false, comment: "年度(期)"
    t.date     "fixed_at",                                  null: false, comment: "確定日"
    t.integer  "works_count",                               null: false, comment: "合計作業数"
    t.integer  "hours",                                     null: false, comment: "合計作業工数"
    t.decimal  "works_amount",    precision: 8,             null: false, comment: "合計作業日当"
    t.decimal  "machines_amount", precision: 8,             null: false, comment: "合計機械利用料"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "homes", force: :cascade, comment: "世帯マスタ" do |t|
    t.string   "phonetic",            limit: 15,                              comment: "世帯名(よみ)"
    t.string   "name",                limit: 10,                              comment: "世帯名"
    t.integer  "worker_id",                                                   comment: "世帯主(代表者)"
    t.string   "zip_code",            limit: 7,                               comment: "郵便番号"
    t.string   "address1",            limit: 50,                              comment: "住所1"
    t.string   "address2",            limit: 50,                              comment: "住所2"
    t.string   "telephone",           limit: 15,                              comment: "電話番号"
    t.string   "fax",                 limit: 15,                              comment: "FAX番号"
    t.integer  "section_id",                                                  comment: "班／町内"
    t.integer  "display_order",                                               comment: "表示順"
    t.boolean  "member_flag",                    default: true,  null: false, comment: "組合員フラグ"
    t.boolean  "worker_payment_flag",            default: false, null: false, comment: "個人支払フラグ"
    t.boolean  "company_flag",                   default: false, null: false, comment: "営農組合フラグ"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "homes", ["deleted_at"], name: "index_homes_on_deleted_at", using: :btree

  create_table "lands", force: :cascade, comment: "土地マスタ" do |t|
    t.string   "place",         limit: 15,                                        null: false, comment: "番地"
    t.integer  "owner_id",                                                                     comment: "所有者"
    t.integer  "manager_id",                                                                   comment: "管理者"
    t.decimal  "area",                     precision: 5, scale: 2,                null: false, comment: "面積(α)"
    t.integer  "display_order",                                                                comment: "表示順"
    t.boolean  "target_flag",                                      default: true, null: false, comment: "管理対象フラグ"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "lands", ["deleted_at"], name: "index_lands_on_deleted_at", using: :btree
  add_index "lands", ["place"], name: "index_lands_on_place", using: :btree

  create_table "machine_kinds", force: :cascade, comment: "作業種別機械利用可能マスタ" do |t|
    t.integer "machine_type_id", null: false, comment: "機械種別"
    t.integer "work_kind_id",    null: false, comment: "作業種別"
  end

  add_index "machine_kinds", ["machine_type_id", "work_kind_id"], name: "machine_kinds_2nd_key", unique: true, using: :btree

  create_table "machine_price_details", force: :cascade, comment: "機械利用単価マスタ(明細)" do |t|
    t.integer  "machine_price_header_id",                           null: false, comment: "単価ヘッダ"
    t.integer  "lease_id",                                          null: false, comment: "リース"
    t.integer  "work_kind_id",                          default: 0, null: false, comment: "作業種別"
    t.integer  "adjust_id",                                                      comment: "単位"
    t.decimal  "price",                   precision: 5, default: 0, null: false, comment: "単価"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  add_index "machine_price_details", ["machine_price_header_id", "lease_id", "work_kind_id"], name: "machine_price_details_2nd_key", unique: true, using: :btree

  create_table "machine_price_headers", force: :cascade, comment: "機械利用単価マスタ(ヘッダ)" do |t|
    t.date     "validated_at",                null: false, comment: "起点日"
    t.integer  "machine_id",      default: 0, null: false, comment: "機械"
    t.integer  "machine_type_id", default: 0, null: false, comment: "機械種別"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "machine_price_headers", ["validated_at", "machine_id", "machine_type_id"], name: "machine_price_headers_2nd_key", unique: true, using: :btree

  create_table "machine_results", force: :cascade, comment: "機械稼動データ" do |t|
    t.integer  "machine_id",                                                         comment: "機械"
    t.integer  "work_result_id",                                                     comment: "作業結果データ"
    t.integer  "display_order",                           default: 1,   null: false, comment: "表示順"
    t.decimal  "hours",           precision: 3, scale: 1, default: 0.0, null: false, comment: "稼動時間"
    t.decimal  "fixed_quantity",  precision: 6, scale: 2,                            comment: "確定稼動量"
    t.integer  "fixed_adjust_id",                                                    comment: "確定稼動単位"
    t.decimal  "fixed_price",     precision: 5,                                      comment: "確定稼動単価"
    t.decimal  "fixed_amount",    precision: 7,                                      comment: "確定使用料"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "machine_results", ["machine_id", "work_result_id"], name: "index_machine_results_on_machine_id_and_work_result_id", unique: true, using: :btree

  create_table "machine_types", force: :cascade, comment: "機械種別マスタ" do |t|
    t.string   "name",          limit: 10,             null: false, comment: "機械種別名称"
    t.integer  "display_order",            default: 1, null: false, comment: "表示順"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "machines", force: :cascade, comment: "機械マスタ" do |t|
    t.string   "name",              limit: 40,             null: false, comment: "機械名称"
    t.integer  "display_order",                            null: false, comment: "表示順"
    t.date     "validity_start_at",                                     comment: "稼動開始日"
    t.date     "validity_end_at",                                       comment: "稼動終了(予定)日"
    t.integer  "machine_type_id",              default: 0, null: false, comment: "機械種別"
    t.integer  "home_id",                      default: 0, null: false, comment: "所有者"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "organizations", force: :cascade, comment: "組織(体系)マスタ" do |t|
    t.string   "name",            limit: 20,                     null: false, comment: "組織名称"
    t.integer  "workers_count",              default: 12,        null: false, comment: "作業日報の作業者数"
    t.integer  "lands_count",                default: 17,        null: false, comment: "作業日報の土地数"
    t.integer  "machines_count",             default: 8,         null: false, comment: "作業日報の機械数"
    t.integer  "chemicals_count",            default: 4,         null: false, comment: "作業日報の薬剤数"
    t.integer  "daily_worker",    limit: 2,  default: 0,         null: false, comment: "作業日報の作業者名付加情報"
    t.string   "consignor_code",  limit: 10,                                  comment: "委託者コード"
    t.string   "consignor_name",  limit: 40,                                  comment: "委託者コード"
    t.string   "bank_code",       limit: 4,  default: "0000",    null: false, comment: "口座の金融機関コード"
    t.string   "branch_code",     limit: 3,  default: "000",     null: false, comment: "口座の支店コード"
    t.integer  "account_type_id", limit: 2,  default: 0,         null: false, comment: "口座種別"
    t.string   "account_number",  limit: 7,  default: "0000000", null: false, comment: "口座番号"
    t.integer  "term",                       default: 0,         null: false, comment: "現在の年度(期)"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", force: :cascade, comment: "班／町内マスタ" do |t|
    t.string   "name",          limit: 40,                null: false, comment: "班名称"
    t.integer  "display_order",            default: 1,    null: false, comment: "表示順"
    t.boolean  "work_flag",                default: true, null: false, comment: "作業班フラグ"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "sections", ["deleted_at"], name: "index_sections_on_deleted_at", using: :btree

  create_table "systems", force: :cascade, comment: "システムマスタ" do |t|
    t.integer  "term",        null: false, comment: "年度(期)"
    t.date     "target_from",              comment: "開始年月"
    t.date     "target_to",                comment: "終了年月"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "systems", ["term"], name: "index_systems_on_term", unique: true, using: :btree

  create_table "work_chemicals", force: :cascade, comment: "薬剤使用データ" do |t|
    t.integer  "work_id",                               null: false, comment: "作業"
    t.integer  "chemical_id",                           null: false, comment: "薬剤"
    t.decimal  "quantity",    precision: 3, default: 0, null: false, comment: "使用料"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "work_chemicals", ["work_id", "chemical_id"], name: "index_work_chemicals_on_work_id_and_chemical_id", unique: true, using: :btree

  create_table "work_kind_prices", force: :cascade, comment: "作業単価マスタ" do |t|
    t.integer  "term",                                      null: false, comment: "年度(期)"
    t.integer  "work_kind_id",                              null: false, comment: "作業種別"
    t.decimal  "price",        precision: 5, default: 1000, null: false, comment: "単価"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "work_kind_prices", ["term", "work_kind_id"], name: "index_work_kind_prices_on_term_and_work_kind_id", unique: true, using: :btree

  create_table "work_kind_types", force: :cascade, comment: "作業種別分類対応マスタ" do |t|
    t.integer "work_kind_id", comment: "作業種別"
    t.integer "work_type_id", comment: "作業分類"
  end

  add_index "work_kind_types", ["work_kind_id", "work_type_id"], name: "index_work_kind_types_on_work_kind_id_and_work_type_id", unique: true, using: :btree

  create_table "work_kinds", force: :cascade, comment: "作業種別マスタ" do |t|
    t.string   "name",          limit: 20,                 null: false, comment: "作業種別名称"
    t.integer  "display_order",                            null: false, comment: "表示順"
    t.boolean  "other_flag",               default: false, null: false, comment: "その他フラグ"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "work_kinds", ["deleted_at"], name: "index_work_kinds_on_deleted_at", using: :btree

  create_table "work_lands", force: :cascade, comment: "作業地データ" do |t|
    t.integer  "work_id",                                comment: "作業"
    t.integer  "land_id",                                comment: "土地"
    t.integer  "display_order", default: 0, null: false, comment: "表示順"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "work_lands", ["work_id", "land_id"], name: "index_work_lands_on_work_id_and_land_id", unique: true, using: :btree

  create_table "work_results", force: :cascade, comment: "作業結果データ" do |t|
    t.integer  "work_id",                                                          comment: "作業"
    t.integer  "worker_id",                                                        comment: "作業者"
    t.decimal  "hours",         precision: 5, scale: 1, default: 0.0, null: false, comment: "作業時間"
    t.integer  "display_order",                         default: 0,   null: false, comment: "表示順"
    t.decimal  "fixed_hours",   precision: 5, scale: 1,                            comment: "確定作業時間"
    t.decimal  "fixed_price",   precision: 5,                                      comment: "確定作業単価"
    t.decimal  "fixed_amount",  precision: 7,                                      comment: "確定作業日当"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "work_results", ["work_id", "worker_id"], name: "index_work_results_on_work_id_and_worker_id", unique: true, using: :btree

  create_table "work_types", force: :cascade, comment: "作業分類マスタ" do |t|
    t.integer  "genre",                                    null: false, comment: "作業ジャンル"
    t.string   "name",          limit: 10,                 null: false, comment: "作業分類名称"
    t.boolean  "category_flag",            default: false,              comment: "カテゴリーフラグ"
    t.integer  "display_order",            default: 0,     null: false, comment: "表示順"
    t.datetime "deleted_at"
  end

  add_index "work_types", ["deleted_at"], name: "index_work_types_on_deleted_at", using: :btree

  create_table "workers", force: :cascade, comment: "作業者マスタ" do |t|
    t.string   "family_phonetic", limit: 15,                     null: false, comment: "姓(ﾌﾘｶﾞﾅ)"
    t.string   "family_name",     limit: 10,                     null: false, comment: "姓"
    t.string   "first_phonetic",  limit: 15,                     null: false, comment: "名(ﾌﾘｶﾞﾅ)"
    t.string   "first_name",      limit: 10,                     null: false, comment: "名"
    t.date     "birthday",                                                    comment: "誕生日"
    t.integer  "home_id",                                                     comment: "世帯"
    t.string   "mobile",          limit: 15,                                  comment: "携帯番号"
    t.string   "mobile_mail",     limit: 50,                                  comment: "メールアドレス(携帯)"
    t.string   "pc_mail",         limit: 50,                                  comment: "メールアドレス(PC)"
    t.integer  "display_order",                                               comment: "表示順"
    t.boolean  "work_flag",                  default: true,      null: false, comment: "作業フラグ"
    t.integer  "gender_id",                  default: 0,         null: false, comment: "性別"
    t.string   "bank_code",       limit: 4,  default: "0000",    null: false, comment: "口座(金融機関)"
    t.string   "branch_code",     limit: 3,  default: "000",     null: false, comment: "口座(支店)"
    t.integer  "account_type_id", limit: 2,  default: 0,         null: false, comment: "口座種別"
    t.string   "account_number",  limit: 7,  default: "0000000", null: false, comment: "口座番号"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "workers", ["deleted_at"], name: "index_workers_on_deleted_at", using: :btree

  create_table "works", force: :cascade, comment: "作業データ" do |t|
    t.integer  "term",                                null: false, comment: "年度(期)"
    t.date     "worked_at",                           null: false, comment: "作業日"
    t.integer  "weather_id",                                       comment: "天気"
    t.integer  "work_type_id",                                     comment: "作業分類"
    t.string   "name",         limit: 40,             null: false, comment: "作業名称"
    t.text     "remarks",                                          comment: "備考"
    t.datetime "start_at",                            null: false, comment: "開始時刻"
    t.datetime "end_at",                              null: false, comment: "終了時刻"
    t.date     "fixed_at",                                         comment: "確定日"
    t.integer  "work_kind_id",            default: 0, null: false, comment: "作業種別"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
