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

ActiveRecord::Schema.define(version: 2019_12_22_080730) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "adjustments", comment: "調整", force: :cascade do |t|
    t.integer "drying_id", default: 0, null: false, comment: "乾燥"
    t.integer "home_id", comment: "担当世帯"
    t.date "carried_on", comment: "搬入日"
    t.date "shipped_on", comment: "出荷日"
    t.decimal "rice_bag", precision: 3, comment: "調整米(袋)"
    t.decimal "half_weight", precision: 3, scale: 1, comment: "半端米(kg)"
    t.decimal "waste_weight", precision: 5, scale: 1, comment: "くず米(kg)"
    t.decimal "fixed_amount", precision: 7, comment: "確定額"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drying_id"], name: "adjustments_secondary", unique: true
  end

  create_table "bank_branches", primary_key: ["bank_code", "code"], comment: "支店マスタ", force: :cascade do |t|
    t.string "bank_code", limit: 4, null: false, comment: "金融機関コード"
    t.string "code", limit: 3, null: false, comment: "支店コード"
    t.string "name", limit: 40, null: false, comment: "支店名称"
    t.string "phonetic", limit: 40, null: false, comment: "支店名称(ﾌﾘｶﾞﾅ)"
    t.string "zip_code", limit: 7, comment: "郵便番号"
    t.string "address1", limit: 50, comment: "住所1"
    t.string "address2", limit: 50, comment: "住所2"
    t.string "telephone", limit: 15, comment: "電話番号"
    t.string "fax", limit: 15, comment: "FAX番号"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "banks", primary_key: "code", id: :string, limit: 4, comment: "金融機関コード", comment: "金融機関マスタ", force: :cascade do |t|
    t.string "name", limit: 40, null: false, comment: "金融機関名称"
    t.string "phonetic", limit: 40, null: false, comment: "金融機関名称(ﾌﾘｶﾞﾅ)"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "broccoli_boxes", id: :serial, comment: "ブロッコリ箱マスタ", comment: "ブロッコリ箱マスタ", force: :cascade do |t|
    t.decimal "weight", precision: 3, scale: 1, default: "0.0", null: false, comment: "重さ(kg)"
    t.string "display_name", limit: 10, default: "", null: false, comment: "表示名"
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "broccoli_harvests", id: :serial, comment: "ブロッコリー収穫", comment: "ブロッコリー収穫", force: :cascade do |t|
    t.integer "work_broccoli_id", null: false, comment: "ブロッコリー作業"
    t.integer "broccoli_rank_id", null: false, comment: "ブロッコリー等級"
    t.integer "broccoli_size_id", null: false, comment: "ブロッコリー階級"
    t.decimal "inspection", precision: 3, default: "0", null: false, comment: "検査後数量"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["work_broccoli_id", "broccoli_rank_id", "broccoli_size_id"], name: "broccoli_harvest_sheet", unique: true
  end

  create_table "broccoli_ranks", id: :serial, comment: "ブロッコリ等級マスタ", comment: "ブロッコリ等級マスタ", force: :cascade do |t|
    t.string "display_name", limit: 10, default: "", null: false, comment: "表示名"
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "broccoli_sizes", id: :serial, comment: "ブロッコリ階級マスタ", comment: "ブロッコリ階級マスタ", force: :cascade do |t|
    t.string "display_name", limit: 10, default: "", null: false, comment: "表示名"
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "calendar_work_kinds", comment: "カレンダー作業種別", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "利用者"
    t.integer "work_kind_id", null: false, comment: "作業種別"
    t.string "text_color", limit: 8, default: "#000000", null: false, comment: "文字色"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "work_kind_id"], name: "calendar_work_kind_index", unique: true
  end

  create_table "chemical_kinds", id: :serial, comment: "作業種別薬剤種別利用マスタ", comment: "作業種別薬剤種別利用マスタ", force: :cascade do |t|
    t.integer "chemical_type_id", null: false, comment: "薬剤種別"
    t.integer "work_kind_id", null: false, comment: "作業種別"
    t.index ["chemical_type_id", "work_kind_id"], name: "index_chemical_kinds_on_chemical_type_id_and_work_kind_id", unique: true
  end

  create_table "chemical_terms", id: :serial, comment: "薬剤年度別利用マスタ", force: :cascade do |t|
    t.integer "chemical_id", null: false, comment: "薬剤"
    t.integer "term", null: false, comment: "年度(期)"
    t.decimal "price", precision: 6, default: "0", null: false, comment: "価格"
    t.index ["chemical_id", "term"], name: "index_chemical_terms_on_chemical_id_and_term", unique: true
  end

  create_table "chemical_types", id: :serial, comment: "薬剤種別マスタ", comment: "薬剤種別マスタ", force: :cascade do |t|
    t.string "name", limit: 20, null: false, comment: "薬剤種別名称"
    t.integer "display_order", default: 1, null: false, comment: "表示順"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chemical_work_types", id: :serial, force: :cascade do |t|
    t.integer "chemical_term_id", comment: "薬剤利用"
    t.integer "work_type_id", comment: "作業分類"
    t.decimal "quantity", precision: 5, scale: 1, default: "0.0", null: false, comment: "使用量"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chemical_term_id", "work_type_id"], name: "index_chemical_work_types_on_chemical_term_id_and_work_type_id", unique: true
  end

  create_table "chemicals", id: :serial, comment: "薬剤マスタ", comment: "薬剤マスタ", force: :cascade do |t|
    t.string "name", limit: 20, null: false, comment: "薬剤名称"
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.integer "chemical_type_id", null: false, comment: "薬剤種別"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string "unit", limit: 2, default: "袋", null: false, comment: "単位"
    t.index ["deleted_at"], name: "index_chemicals_on_deleted_at"
  end

  create_table "daily_weathers", primary_key: "target_date", id: :date, comment: "対象日", comment: "気象", force: :cascade do |t|
    t.float "height", comment: "最高気温"
    t.float "lowest", comment: "最低気温"
    t.float "humidity", comment: "湿度"
    t.float "sunshine", comment: "日照時間"
    t.float "rain", comment: "降水量"
    t.float "snow", comment: "降雪量"
    t.float "pressure", comment: "気圧"
    t.float "wind_speed", comment: "風速"
    t.string "wind_direction", limit: 3, comment: "風向"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
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

  create_table "depreciation_types", id: :serial, comment: "減価償却分類", comment: "減価償却分類", force: :cascade do |t|
    t.integer "depreciation_id", comment: "減価償却"
    t.integer "work_type_id", null: false, comment: "作業分類"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["depreciation_id", "work_type_id"], name: "index_depreciation_types_on_depreciation_id_and_work_type_id", unique: true
  end

  create_table "depreciations", id: :serial, comment: "減価償却", comment: "減価償却", force: :cascade do |t|
    t.integer "term", null: false, comment: "年度(期)"
    t.integer "machine_id", comment: "機械"
    t.decimal "cost", precision: 9, default: "0", null: false, comment: "減価償却費"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["term", "machine_id"], name: "index_depreciations_on_term_and_machine_id", unique: true
  end

  create_table "drying_lands", comment: "乾燥調整場所", force: :cascade do |t|
    t.integer "drying_id", default: 0, null: false, comment: "乾燥調整"
    t.integer "land_id", comment: "作業地"
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.decimal "percentage", precision: 4, scale: 1, default: "100.0", null: false, comment: "割合"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drying_id", "display_order"], name: "drying_lands_3rd", unique: true
  end

  create_table "drying_moths", comment: "乾燥籾", force: :cascade do |t|
    t.integer "drying_id", default: 0, null: false, comment: "乾燥調整"
    t.integer "moth_count", default: 0, null: false, comment: "回数"
    t.integer "moth_no", comment: "No."
    t.decimal "water_content", precision: 3, scale: 1, comment: "水分"
    t.decimal "moth_weight", precision: 5, scale: 1, comment: "籾(kg)"
    t.decimal "rice_weight", precision: 5, scale: 1, comment: "玄米(kg)"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drying_id", "moth_count"], name: "drying_moths_secondary", unique: true
  end

  create_table "dryings", comment: "乾燥", force: :cascade do |t|
    t.integer "term", null: false, comment: "年度(期)"
    t.integer "work_type_id", comment: "作業分類"
    t.integer "home_id", default: 0, null: false, comment: "担当世帯"
    t.integer "drying_type_id", default: 0, null: false, comment: "乾燥種別"
    t.date "carried_on", null: false, comment: "搬入日"
    t.date "shipped_on", comment: "出荷日"
    t.decimal "water_content", precision: 3, scale: 1, comment: "水分"
    t.decimal "fixed_amount", precision: 7, comment: "確定額"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carried_on", "home_id"], name: "dryings_secondary", unique: true
  end

  create_table "expense_types", comment: "経費種別", force: :cascade do |t|
    t.string "name", limit: 10, default: "", null: false, comment: "経費種別名称"
    t.boolean "chemical_flag", default: false, null: false, comment: "薬剤フラグ"
    t.boolean "sales_flag", default: false, null: false, comment: "売上フラグ"
    t.boolean "other_flag", default: false, null: false, comment: "その他フラグ"
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at", comment: "削除年月日"
  end

  create_table "expense_work_types", id: :serial, comment: "経費作業種別", comment: "経費作業種別", force: :cascade do |t|
    t.integer "expense_id", comment: "経費"
    t.integer "work_type_id", comment: "作業分類"
    t.decimal "rate", precision: 5, scale: 2, default: "0.0", null: false, comment: "割合"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_id", "work_type_id"], name: "index_expense_work_types_on_expense_id_and_work_type_id", unique: true
  end

  create_table "expenses", id: :serial, comment: "経費", comment: "経費", force: :cascade do |t|
    t.integer "term", null: false, comment: "年度(期)"
    t.date "payed_on", null: false, comment: "支払日"
    t.string "content", limit: 40, comment: "支払内容"
    t.decimal "amount", precision: 7, default: "0", null: false, comment: "支払金額"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "chemical_type_id", default: 0, comment: "薬剤種別"
    t.integer "chemical_id", comment: "薬剤"
    t.integer "expense_type_id", default: 0, null: false, comment: "経費種別"
    t.decimal "quantity", precision: 4, comment: "数量"
    t.decimal "discount", precision: 7, comment: "割引額"
    t.decimal "discount_numor", precision: 7, comment: "割引率(分子)"
    t.decimal "discount_denom", precision: 7, comment: "割引率(分母)"
    t.boolean "cost_flag", default: false, null: false, comment: "支払時原価フラグ"
  end

  create_table "fixes", primary_key: ["term", "fixed_at"], comment: "確定データ", force: :cascade do |t|
    t.integer "term", default: 0, null: false, comment: "年度(期)"
    t.date "fixed_at", null: false, comment: "確定日"
    t.integer "works_count", null: false, comment: "合計作業数"
    t.integer "hours", null: false, comment: "合計作業工数"
    t.decimal "works_amount", precision: 8, null: false, comment: "合計作業日当"
    t.decimal "machines_amount", precision: 8, null: false, comment: "合計機械利用料"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "fixed_by", comment: "確定者"
  end

  create_table "homes", id: :serial, comment: "世帯マスタ", comment: "世帯マスタ", force: :cascade do |t|
    t.string "phonetic", limit: 15, comment: "世帯名(よみ)"
    t.string "name", limit: 10, comment: "世帯名"
    t.integer "worker_id", comment: "世帯主(代表者)"
    t.string "zip_code", limit: 7, comment: "郵便番号"
    t.string "address1", limit: 50, comment: "住所1"
    t.string "address2", limit: 50, comment: "住所2"
    t.string "telephone", limit: 15, comment: "電話番号"
    t.string "fax", limit: 15, comment: "FAX番号"
    t.integer "section_id", comment: "班／町内"
    t.integer "display_order", comment: "表示順"
    t.boolean "member_flag", default: true, null: false, comment: "組合員フラグ"
    t.boolean "worker_payment_flag", default: false, null: false, comment: "個人支払フラグ"
    t.boolean "company_flag", default: false, null: false, comment: "営農組合フラグ"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.boolean "owner_flag", default: false, null: false, comment: "所有者フラグ"
    t.integer "finance_order", comment: "出力順(会計用)"
    t.integer "drying_order", comment: "出力順(乾燥調整用)"
    t.integer "owned_rice_order", comment: "出力順(保有米)"
    t.index ["deleted_at"], name: "index_homes_on_deleted_at"
  end

  create_table "land_costs", id: :serial, comment: "土地原価", comment: "土地原価", force: :cascade do |t|
    t.integer "land_id", null: false, comment: "土地"
    t.integer "work_type_id", null: false, comment: "作業分類"
    t.decimal "cost", precision: 7, scale: 1, default: "0.0", null: false, comment: "原価"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "activated_on", default: "1900-01-01", null: false, comment: "有効日"
    t.index ["activated_on", "land_id"], name: "index_land_costs_on_activated_on_and_land_id", unique: true
  end

  create_table "land_places", id: :serial, comment: "場所マスタ", comment: "場所マスタ", force: :cascade do |t|
    t.string "name", limit: 40, null: false, comment: "場所名称"
    t.text "remarks", comment: "備考"
    t.integer "display_order", comment: "表示順"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "lands", id: :serial, comment: "土地マスタ", comment: "土地マスタ", force: :cascade do |t|
    t.string "place", limit: 15, null: false, comment: "番地"
    t.integer "owner_id", comment: "所有者"
    t.integer "manager_id", comment: "管理者"
    t.decimal "area", precision: 5, scale: 2, null: false, comment: "面積(α)"
    t.integer "display_order", comment: "表示順"
    t.boolean "target_flag", default: true, null: false, comment: "管理対象フラグ"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer "land_place_id", comment: "土地"
    t.decimal "reg_area", precision: 5, scale: 2, comment: "登記面積"
    t.string "broccoli_mark", limit: 1, comment: "ブロッコリ記号"
    t.index ["deleted_at"], name: "index_lands_on_deleted_at"
    t.index ["place"], name: "index_lands_on_place"
  end

  create_table "machine_kinds", id: :serial, comment: "作業種別機械利用可能マスタ", comment: "作業種別機械利用可能マスタ", force: :cascade do |t|
    t.integer "machine_type_id", null: false, comment: "機械種別"
    t.integer "work_kind_id", null: false, comment: "作業種別"
    t.index ["machine_type_id", "work_kind_id"], name: "machine_kinds_2nd_key", unique: true
  end

  create_table "machine_price_details", id: :serial, comment: "機械利用単価マスタ(明細)", comment: "機械利用単価マスタ(明細)", force: :cascade do |t|
    t.integer "machine_price_header_id", null: false, comment: "単価ヘッダ"
    t.integer "lease_id", null: false, comment: "リース"
    t.integer "work_kind_id", default: 0, null: false, comment: "作業種別"
    t.integer "adjust_id", comment: "単位"
    t.decimal "price", precision: 5, default: "0", null: false, comment: "単価"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["machine_price_header_id", "lease_id", "work_kind_id"], name: "machine_price_details_2nd_key", unique: true
  end

  create_table "machine_price_headers", id: :serial, comment: "機械利用単価マスタ(ヘッダ)", comment: "機械利用単価マスタ(ヘッダ)", force: :cascade do |t|
    t.date "validated_at", null: false, comment: "起点日"
    t.integer "machine_id", default: 0, null: false, comment: "機械"
    t.integer "machine_type_id", default: 0, null: false, comment: "機械種別"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["validated_at", "machine_id", "machine_type_id"], name: "machine_price_headers_2nd_key", unique: true
  end

  create_table "machine_results", id: :serial, comment: "機械稼動データ", comment: "機械稼動データ", force: :cascade do |t|
    t.integer "machine_id", comment: "機械"
    t.integer "work_result_id", comment: "作業結果データ"
    t.integer "display_order", default: 1, null: false, comment: "表示順"
    t.decimal "hours", precision: 3, scale: 1, default: "0.0", null: false, comment: "稼動時間"
    t.decimal "fixed_quantity", precision: 6, scale: 2, comment: "確定稼動量"
    t.integer "fixed_adjust_id", comment: "確定稼動単位"
    t.decimal "fixed_price", precision: 5, comment: "確定稼動単価"
    t.decimal "fixed_amount", precision: 7, comment: "確定使用料"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "fuel_usage", precision: 5, scale: 2, default: "0.0", null: false, comment: "燃料使用量"
    t.index ["machine_id", "work_result_id"], name: "index_machine_results_on_machine_id_and_work_result_id", unique: true
  end

  create_table "machine_types", id: :serial, comment: "機械種別マスタ", comment: "機械種別マスタ", force: :cascade do |t|
    t.string "name", limit: 10, null: false, comment: "機械種別名称"
    t.integer "display_order", default: 1, null: false, comment: "表示順"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "machines", id: :serial, comment: "機械マスタ", comment: "機械マスタ", force: :cascade do |t|
    t.string "name", limit: 40, null: false, comment: "機械名称"
    t.integer "display_order", null: false, comment: "表示順"
    t.date "validity_start_at", comment: "稼動開始日"
    t.date "validity_end_at", comment: "稼動終了(予定)日"
    t.integer "machine_type_id", default: 0, null: false, comment: "機械種別"
    t.integer "home_id", default: 0, null: false, comment: "所有者"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.boolean "diesel_flag", default: false, null: false, comment: "ディーゼル"
  end

  create_table "minutes", comment: "議事録", force: :cascade do |t|
    t.integer "schedule_id", default: 0, null: false, comment: "作業予定"
    t.string "pdf_name", limit: 50, comment: "PDFファイル名"
    t.binary "pdf", comment: "PDF"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["schedule_id"], name: "index_minutes_on_schedule_id", unique: true
  end

  create_table "organizations", id: :serial, comment: "組織(体系)マスタ", comment: "組織(体系)マスタ", force: :cascade do |t|
    t.string "name", limit: 20, null: false, comment: "組織名称"
    t.integer "workers_count", default: 12, null: false, comment: "作業日報の作業者数"
    t.integer "lands_count", default: 17, null: false, comment: "作業日報の土地数"
    t.integer "machines_count", default: 8, null: false, comment: "作業日報の機械数"
    t.integer "chemicals_count", default: 4, null: false, comment: "作業日報の薬剤数"
    t.integer "daily_worker", limit: 2, default: 0, null: false, comment: "作業日報の作業者名付加情報"
    t.string "consignor_code", limit: 10, comment: "委託者コード"
    t.string "consignor_name", limit: 40, comment: "委託者コード"
    t.string "bank_code", limit: 4, default: "0000", null: false, comment: "口座の金融機関コード"
    t.string "branch_code", limit: 3, default: "000", null: false, comment: "口座の支店コード"
    t.integer "account_type_id", limit: 2, default: 0, null: false, comment: "口座種別"
    t.string "account_number", limit: 7, default: "0000000", null: false, comment: "口座番号"
    t.integer "term", default: 0, null: false, comment: "現在の年度(期)"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "url", comment: "URL"
    t.integer "broccoli_work_type_id", comment: "ブロッコリ作業分類"
    t.integer "broccoli_work_kind_id", comment: "ブロッコリ種別分類"
    t.integer "chemical_group_count", default: 1, comment: "薬剤グループ数"
    t.integer "rice_planting_id", comment: "田植作業種別"
    t.integer "whole_crop_work_kind_id", comment: "WCS収穫分類"
    t.integer "contract_work_type_id", comment: "受託作業分類"
    t.integer "harvesting_work_kind_id", comment: "稲刈作業種別"
  end

  create_table "owned_rice_prices", comment: "保有米単価", force: :cascade do |t|
    t.integer "term", null: false, comment: "年度(期)"
    t.integer "work_type_id", default: 0, null: false, comment: "品種"
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.string "name", limit: 10, default: "", null: false, comment: "品種名"
    t.string "short_name", limit: 5, default: "", null: false, comment: "品種名(略称)"
    t.decimal "owned_price", precision: 5, default: "0", null: false, comment: "保有米価格"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["term", "work_type_id"], name: "owned_rice_prices_2nd", unique: true
  end

  create_table "owned_rices", comment: "保有米", force: :cascade do |t|
    t.integer "home_id", default: 0, null: false, comment: "購入世帯"
    t.integer "owned_rice_price_id", default: 0, null: false, comment: "保有米単価"
    t.decimal "owned_count", precision: 3, default: "0", null: false, comment: "保有米数"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["home_id", "owned_rice_price_id"], name: "owned_rices_2nd", unique: true
  end

  create_table "schedule_workers", id: :serial, comment: "作業予定作業者", comment: "作業予定作業者", force: :cascade do |t|
    t.integer "schedule_id", comment: "作業予定"
    t.integer "worker_id", comment: "作業者"
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid", limit: 36, comment: "UUID(カレンダー用)"
    t.index ["schedule_id", "worker_id"], name: "index_schedule_workers_on_schedule_id_and_worker_id", unique: true
  end

  create_table "schedules", id: :serial, comment: "作業予定", comment: "作業予定", force: :cascade do |t|
    t.integer "term", null: false, comment: "年度(期)"
    t.date "worked_at", null: false, comment: "作業予定日"
    t.integer "work_type_id", comment: "作業分類"
    t.integer "work_kind_id", default: 0, null: false, comment: "作業種別"
    t.string "name", limit: 40, null: false, comment: "作業名称"
    t.boolean "work_flag", default: true, null: false, comment: "作業フラグ"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_at", default: "1970-01-01 08:00:00", null: false, comment: "開始予定時刻"
    t.datetime "end_at", default: "1970-01-01 17:00:00", null: false, comment: "終了予定時刻"
  end

  create_table "sections", id: :serial, comment: "班／町内マスタ", comment: "班／町内マスタ", force: :cascade do |t|
    t.string "name", limit: 40, null: false, comment: "班名称"
    t.integer "display_order", default: 1, null: false, comment: "表示順"
    t.boolean "work_flag", default: true, null: false, comment: "作業班フラグ"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_sections_on_deleted_at"
  end

  create_table "seedling_homes", id: :serial, comment: "育苗担当世帯", comment: "育苗担当世帯", force: :cascade do |t|
    t.integer "seedling_id", comment: "育苗"
    t.integer "home_id", comment: "世帯"
    t.decimal "quantity", precision: 4, default: "0", null: false, comment: "苗箱数"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "sowed_on", comment: "播種日"
    t.index ["seedling_id", "home_id"], name: "index_seedling_homes_on_seedling_id_and_home_id", unique: true
  end

  create_table "seedling_results", id: :serial, comment: "育苗結果", comment: "育苗結果", force: :cascade do |t|
    t.integer "seedling_home_id", comment: "育苗担当"
    t.integer "work_result_id", comment: "作業結果"
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.decimal "quantity", precision: 3, default: "0", null: false, comment: "苗箱数"
    t.boolean "disposal_flag", default: false, null: false, comment: "廃棄フラグ"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["seedling_home_id", "work_result_id", "display_order"], name: "seedling_results_2nd_key", unique: true
  end

  create_table "seedlings", id: :serial, comment: "育苗", comment: "育苗", force: :cascade do |t|
    t.integer "term", null: false, comment: "年度(期)"
    t.integer "work_type_id", comment: "作業分類"
    t.decimal "soil_quantity", precision: 4, default: "0", null: false, comment: "育苗土数"
    t.decimal "seed_cost", precision: 6, default: "0", null: false, comment: "種子原価"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["term", "work_type_id"], name: "index_seedlings_on_term_and_work_type_id", unique: true
  end

  create_table "systems", id: :serial, comment: "システムマスタ", comment: "システムマスタ", force: :cascade do |t|
    t.integer "term", null: false, comment: "年度(期)"
    t.date "target_from", comment: "開始年月"
    t.date "target_to", comment: "終了年月"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date "start_date", null: false, comment: "期首日"
    t.date "end_date", null: false, comment: "期末日"
    t.integer "organization_id", default: 0, null: false, comment: "組織"
    t.decimal "default_price", precision: 5, default: "1000", null: false, comment: "初期値(工賃)"
    t.decimal "default_fee", precision: 6, default: "15000", null: false, comment: "初期値(管理料)"
    t.decimal "light_oil_price", precision: 4, default: "0", null: false, comment: "軽油価格"
    t.decimal "seedling_price", precision: 4, default: "0", null: false, comment: "育苗費"
    t.integer "seedling_chemical_id", default: 0, comment: "育苗土"
    t.decimal "dry_price", precision: 4, default: "0", null: false, comment: "基準額(乾燥のみ)"
    t.decimal "adjust_price", precision: 4, default: "0", null: false, comment: "基準額(調整のみ)"
    t.decimal "dry_adjust_price", precision: 4, default: "0", null: false, comment: "基準額(乾燥調整)"
    t.boolean "half_sum_flag", default: false, null: false, comment: "半端米集計フラグ"
    t.boolean "waste_sum_flag", default: false, null: false, comment: "くず米集計フラグ"
    t.decimal "relative_price", precision: 5, default: "0", null: false, comment: "縁故米加算額"
    t.index ["term", "organization_id"], name: "index_systems_on_term_and_organization_id", unique: true
    t.index ["term"], name: "index_systems_on_term", unique: true
  end

  create_table "total_cost_details", comment: "集計原価(明細)", force: :cascade do |t|
    t.integer "total_cost_id", null: false, comment: "集計原価"
    t.integer "work_type_id", null: false, comment: "作業分類"
    t.decimal "rate", precision: 6, scale: 2, default: "1.0", null: false, comment: "割合"
    t.decimal "area", precision: 7, scale: 2, null: false, comment: "面積(α)"
    t.decimal "cost", precision: 9, comment: "原価"
    t.decimal "base_cost", precision: 9, scale: 3, comment: "原価(10α当)"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["total_cost_id", "work_type_id"], name: "index_total_cost_details_on_total_cost_id_and_work_type_id", unique: true
  end

  create_table "total_costs", comment: "集計原価", force: :cascade do |t|
    t.integer "term", null: false, comment: "年度(期)"
    t.integer "total_cost_type_id", null: false, comment: "集計原価種別"
    t.date "occurred_on", null: false, comment: "発生日"
    t.integer "work_id", comment: "作業"
    t.integer "expense_id", comment: "経費"
    t.integer "depreciation_id", comment: "減価償却"
    t.integer "work_chemical_id", comment: "薬剤使用"
    t.decimal "amount", precision: 9, default: -> { "(0)::numeric" }, null: false, comment: "原価額"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "seedling_home_id", comment: "育苗担当"
    t.boolean "member_flag", default: false, null: false, comment: "組合員支払フラグ"
    t.integer "land_id", comment: "土地"
    t.boolean "fiscal_flag", default: false, null: false, comment: "決算期フラグ"
    t.integer "display_order", default: 0, null: false, comment: "並び順"
    t.integer "whole_crop_land_id", comment: "WCS土地"
    t.index ["term", "occurred_on"], name: "index_total_costs_on_term_and_occurred_on"
  end

  create_table "users", id: :serial, comment: "利用者マスタ", comment: "利用者マスタ", force: :cascade do |t|
    t.string "login_name", limit: 12, null: false, comment: "ログイン名"
    t.string "password_digest", limit: 128, null: false, comment: "パスワード"
    t.integer "worker_id", comment: "作業者"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "term", default: 0, null: false, comment: "期"
    t.date "target_from", default: "2010-01-01", null: false, comment: "開始年月"
    t.date "target_to", default: "2010-12-31", null: false, comment: "終了年月"
    t.integer "organization_id", default: 0, null: false, comment: "組織"
    t.integer "permission_id", default: 0, null: false, comment: "権限"
    t.integer "view_month", default: [1, 4, 8], null: false, comment: "表示切替月", array: true
    t.integer "calendar_term", default: 2018, null: false, comment: "期(カレンダー)"
    t.index ["login_name"], name: "index_users_on_login_name", unique: true
    t.index ["worker_id"], name: "index_users_on_worker_id", unique: true
  end

  create_table "whole_crop_lands", comment: "WCS土地", force: :cascade do |t|
    t.integer "work_whole_crop_id", default: 0, null: false, comment: "WCS作業"
    t.integer "work_land_id", default: 0, null: false, comment: "作業地"
    t.integer "display_order", default: 0, null: false, comment: "番号"
    t.decimal "rolls", precision: 3, default: "0", null: false, comment: "ロール数"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["work_whole_crop_id", "work_land_id"], name: "index_whole_crop_lands_on_work_whole_crop_id_and_work_land_id", unique: true
  end

  create_table "whole_crop_rolls", comment: "WCSロール", force: :cascade do |t|
    t.integer "whole_crop_land_id", default: 0, null: false, comment: "WCS土地"
    t.integer "display_order", default: 0, null: false, comment: "番号"
    t.decimal "weight", precision: 4, scale: 1, default: "0.0", null: false, comment: "重量"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "work_broccolis", id: :serial, comment: "ブロッコリー作業", comment: "ブロッコリー作業", force: :cascade do |t|
    t.integer "work_id", null: false, comment: "作業"
    t.integer "broccoli_box_id", comment: "箱"
    t.date "shipped_on", null: false, comment: "出荷日"
    t.decimal "rest", precision: 3, default: "0", null: false, comment: "残数"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "sale", precision: 6, comment: "販売金額"
    t.decimal "cost", precision: 6, comment: "販売経費"
    t.index ["work_id"], name: "index_work_broccolis_on_work_id", unique: true
  end

  create_table "work_chemicals", id: :serial, comment: "薬剤使用データ", comment: "薬剤使用データ", force: :cascade do |t|
    t.integer "work_id", null: false, comment: "作業"
    t.integer "chemical_id", null: false, comment: "薬剤"
    t.decimal "quantity", precision: 5, scale: 1, default: "0.0", null: false, comment: "使用量"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "chemical_group_no", default: 1, null: false, comment: "薬剤グループ番号"
    t.index ["work_id", "chemical_id", "chemical_group_no"], name: "work_chemicals_2nd_key", unique: true
  end

  create_table "work_kind_prices", id: :serial, comment: "作業単価マスタ", comment: "作業単価マスタ", force: :cascade do |t|
    t.integer "term", null: false, comment: "年度(期)"
    t.integer "work_kind_id", null: false, comment: "作業種別"
    t.decimal "price", precision: 5, default: "1000", null: false, comment: "単価"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["term", "work_kind_id"], name: "index_work_kind_prices_on_term_and_work_kind_id", unique: true
  end

  create_table "work_kind_types", id: :serial, comment: "作業種別分類対応マスタ", comment: "作業種別分類対応マスタ", force: :cascade do |t|
    t.integer "work_kind_id", comment: "作業種別"
    t.integer "work_type_id", comment: "作業分類"
    t.index ["work_kind_id", "work_type_id"], name: "index_work_kind_types_on_work_kind_id_and_work_type_id", unique: true
  end

  create_table "work_kinds", id: :serial, comment: "作業種別マスタ", comment: "作業種別マスタ", force: :cascade do |t|
    t.string "name", limit: 20, null: false, comment: "作業種別名称"
    t.integer "display_order", null: false, comment: "表示順"
    t.boolean "other_flag", default: false, null: false, comment: "その他フラグ"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.boolean "land_flag", default: true, null: false, comment: "土地利用フラグ"
    t.string "broccoli_mark", limit: 1, comment: "ブロッコリ記号"
    t.index ["deleted_at"], name: "index_work_kinds_on_deleted_at"
  end

  create_table "work_lands", id: :serial, comment: "作業地データ", comment: "作業地データ", force: :cascade do |t|
    t.integer "work_id", comment: "作業"
    t.integer "land_id", comment: "土地"
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "fixed_cost", precision: 6, comment: "確定作業原価"
    t.index ["work_id", "land_id"], name: "index_work_lands_on_work_id_and_land_id", unique: true
  end

  create_table "work_results", id: :serial, comment: "作業結果データ", comment: "作業結果データ", force: :cascade do |t|
    t.integer "work_id", comment: "作業"
    t.integer "worker_id", comment: "作業者"
    t.decimal "hours", precision: 5, scale: 1, default: "0.0", null: false, comment: "作業時間"
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.decimal "fixed_hours", precision: 5, scale: 1, comment: "確定作業時間"
    t.decimal "fixed_price", precision: 5, comment: "確定作業単価"
    t.decimal "fixed_amount", precision: 7, comment: "確定作業日当"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "uuid", limit: 36, comment: "UUID(カレンダー用)"
    t.index ["work_id", "worker_id"], name: "index_work_results_on_work_id_and_worker_id", unique: true
  end

  create_table "work_types", id: :serial, comment: "作業分類マスタ", comment: "作業分類マスタ", force: :cascade do |t|
    t.integer "genre", null: false, comment: "作業ジャンル"
    t.string "name", limit: 10, null: false, comment: "作業分類名称"
    t.boolean "category_flag", default: false, comment: "カテゴリーフラグ"
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.datetime "deleted_at"
    t.string "bg_color", limit: 8, comment: "背景色"
    t.boolean "land_flag", default: true, null: false, comment: "土地利用"
    t.index ["deleted_at"], name: "index_work_types_on_deleted_at"
  end

  create_table "work_verifications", id: :serial, comment: "日報検証", comment: "日報検証", force: :cascade do |t|
    t.integer "work_id", comment: "作業"
    t.integer "worker_id", comment: "作業者"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["work_id", "worker_id"], name: "index_work_verifications_on_work_id_and_worker_id", unique: true
  end

  create_table "work_whole_crops", comment: "WCS作業", force: :cascade do |t|
    t.integer "work_id", null: false, comment: "作業"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "unit_price", precision: 5, scale: 2, default: "0.0", null: false, comment: "標準単価"
    t.decimal "tax_rate", precision: 3, scale: 1, default: "0.0", null: false, comment: "消費税率"
    t.string "article_name", limit: 15, default: "", null: false, comment: "品名"
    t.index ["work_id"], name: "index_work_whole_crops_on_work_id", unique: true
  end

  create_table "workers", id: :serial, comment: "作業者マスタ", comment: "作業者マスタ", force: :cascade do |t|
    t.string "family_phonetic", limit: 15, null: false, comment: "姓(ﾌﾘｶﾞﾅ)"
    t.string "family_name", limit: 10, null: false, comment: "姓"
    t.string "first_phonetic", limit: 15, null: false, comment: "名(ﾌﾘｶﾞﾅ)"
    t.string "first_name", limit: 10, null: false, comment: "名"
    t.date "birthday", comment: "誕生日"
    t.integer "home_id", comment: "世帯"
    t.string "mobile", limit: 15, comment: "携帯番号"
    t.string "mobile_mail", limit: 50, comment: "メールアドレス(携帯)"
    t.string "pc_mail", limit: 50, comment: "メールアドレス(PC)"
    t.integer "display_order", comment: "表示順"
    t.boolean "work_flag", default: true, null: false, comment: "作業フラグ"
    t.integer "gender_id", default: 0, null: false, comment: "性別"
    t.string "bank_code", limit: 4, default: "0000", null: false, comment: "口座(金融機関)"
    t.string "branch_code", limit: 3, default: "000", null: false, comment: "口座(支店)"
    t.integer "account_type_id", limit: 2, default: 0, null: false, comment: "口座種別"
    t.string "account_number", limit: 7, default: "0000000", null: false, comment: "口座番号"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string "token", limit: 36, default: "", null: false, comment: "アクセストークン"
    t.integer "position_id", default: 0, null: false, comment: "役職"
    t.string "broccoli_mark", limit: 1, comment: "ブロッコリ記号"
    t.index ["deleted_at"], name: "index_workers_on_deleted_at"
    t.index ["token"], name: "index_workers_on_token", unique: true
  end

  create_table "works", id: :serial, comment: "作業データ", comment: "作業データ", force: :cascade do |t|
    t.integer "term", null: false, comment: "年度(期)"
    t.date "worked_at", null: false, comment: "作業日"
    t.integer "weather_id", comment: "天気"
    t.integer "work_type_id", comment: "作業分類"
    t.string "name", limit: 40, null: false, comment: "作業名称"
    t.text "remarks", comment: "備考"
    t.datetime "start_at", null: false, comment: "開始時刻"
    t.datetime "end_at", null: false, comment: "終了時刻"
    t.date "fixed_at", comment: "確定日"
    t.integer "work_kind_id", default: 0, null: false, comment: "作業種別"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "created_by", comment: "作成者"
    t.datetime "printed_at", comment: "印刷日時"
    t.integer "printed_by", comment: "印刷者"
  end

end
