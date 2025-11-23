# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_11_22_083120) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgroonga"

  create_table "accidents", comment: "ヒヤリハット", force: :cascade do |t|
    t.integer "accident_type_id", default: 0, null: false, comment: "ヒヤリハット種別ID"
    t.integer "audience_id", default: 0, null: false, comment: "対象者ID"
    t.text "content", default: "", null: false, comment: "内容"
    t.datetime "created_at", null: false
    t.string "informant_name", limit: 40, default: "", null: false, comment: "情報提供者"
    t.date "investigated_on", null: false, comment: "調査日"
    t.integer "investigator_id", default: 0, null: false, comment: "調査責任者ID"
    t.point "location", comment: "場所"
    t.string "location_name", limit: 40, default: "", null: false, comment: "場所名称"
    t.text "problem", default: "", null: false, comment: "問題点の考察"
    t.text "result", default: "", null: false, comment: "改善の結果"
    t.text "solving", default: "", null: false, comment: "問題解決の考察"
    t.datetime "updated_at", null: false
    t.integer "work_id", null: false, comment: "対象日報"
  end

  create_table "adjustments", comment: "調整", force: :cascade do |t|
    t.date "carried_on", comment: "搬入日"
    t.boolean "container_flag", default: false, null: false, comment: "フレコンフラグ"
    t.datetime "created_at", precision: nil, null: false
    t.integer "drying_id", default: 0, null: false, comment: "乾燥"
    t.decimal "fixed_amount", precision: 7, comment: "確定額"
    t.decimal "half_weight", precision: 3, scale: 1, comment: "半端米(kg)"
    t.integer "home_id", comment: "担当世帯"
    t.decimal "rice_bag", precision: 3, comment: "調整米(袋)"
    t.date "shipped_on", comment: "出荷日"
    t.datetime "updated_at", precision: nil, null: false
    t.date "waste_date", comment: "くず米出荷日"
    t.decimal "waste_weight", precision: 5, scale: 1, comment: "くず米(kg)"
    t.index ["drying_id"], name: "adjustments_secondary", unique: true
  end

  create_table "broccoli_boxes", id: { type: :serial, comment: "ブロッコリ箱マスタ" }, comment: "ブロッコリ箱マスタ", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "display_name", limit: 10, default: "", null: false, comment: "表示名"
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.datetime "updated_at", precision: nil, null: false
    t.decimal "weight", precision: 3, scale: 1, default: "0.0", null: false, comment: "重さ(kg)"
  end

  create_table "broccoli_harvests", id: { type: :serial, comment: "ブロッコリー収穫" }, comment: "ブロッコリー収穫", force: :cascade do |t|
    t.integer "broccoli_rank_id", null: false, comment: "ブロッコリー等級"
    t.integer "broccoli_size_id", null: false, comment: "ブロッコリー階級"
    t.datetime "created_at", precision: nil, null: false
    t.decimal "inspection", precision: 3, default: "0", null: false, comment: "検査後数量"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "work_broccoli_id", null: false, comment: "ブロッコリー作業"
    t.index ["work_broccoli_id", "broccoli_rank_id", "broccoli_size_id"], name: "broccoli_harvest_sheet", unique: true
  end

  create_table "broccoli_ranks", id: { type: :serial, comment: "ブロッコリ等級マスタ" }, comment: "ブロッコリ等級マスタ", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "display_name", limit: 10, default: "", null: false, comment: "表示名"
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "broccoli_sizes", id: { type: :serial, comment: "ブロッコリ階級マスタ" }, comment: "ブロッコリ階級マスタ", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "display_name", limit: 10, default: "", null: false, comment: "表示名"
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "calendar_work_kinds", comment: "カレンダー作業種別", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "text_color", limit: 8, default: "#000000", null: false, comment: "文字色"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id", null: false, comment: "利用者"
    t.integer "work_kind_id", null: false, comment: "作業種別"
    t.index ["user_id", "work_kind_id"], name: "calendar_work_kind_index", unique: true
  end

  create_table "chemical_inventories", comment: "農薬棚卸", force: :cascade do |t|
    t.date "checked_on", null: false, comment: "確認日"
    t.integer "chemical_adjust_type_id", default: 0, null: false, comment: "在庫調整種別"
    t.datetime "created_at", null: false
    t.string "name", limit: 40, default: "", null: false, comment: "棚卸名称"
    t.datetime "updated_at", null: false
  end

  create_table "chemical_kinds", id: { type: :serial, comment: "作業種別薬剤種別利用マスタ" }, comment: "作業種別薬剤種別利用マスタ", force: :cascade do |t|
    t.integer "chemical_type_id", null: false, comment: "薬剤種別"
    t.integer "work_kind_id", null: false, comment: "作業種別"
    t.index ["chemical_type_id", "work_kind_id"], name: "index_chemical_kinds_on_chemical_type_id_and_work_kind_id", unique: true
  end

  create_table "chemical_stocks", comment: "農薬在庫", force: :cascade do |t|
    t.decimal "adjust", precision: 7, scale: 1, default: "0.0", null: false, comment: "調整量"
    t.integer "chemical_id", null: false, comment: "薬剤"
    t.integer "chemical_inventory_id", comment: "薬剤棚卸"
    t.datetime "created_at", null: false
    t.decimal "inventory", precision: 8, scale: 1, comment: "棚卸量"
    t.string "name", limit: 40, default: "", null: false, comment: "在庫名称"
    t.decimal "shipping", precision: 7, scale: 1, comment: "出庫量"
    t.decimal "stock", precision: 8, scale: 1, default: "0.0", null: false, comment: "在庫量"
    t.date "stock_on", null: false, comment: "在庫日"
    t.decimal "stored", precision: 7, scale: 1, comment: "入庫量"
    t.datetime "updated_at", null: false
    t.decimal "using", precision: 7, scale: 1, comment: "使用量"
    t.integer "work_chemical_id", comment: "薬剤使用"
  end

  create_table "chemical_terms", id: :serial, comment: "薬剤年度別利用マスタ", force: :cascade do |t|
    t.integer "chemical_id", null: false, comment: "薬剤"
    t.decimal "price", precision: 6, default: "0", null: false, comment: "価格"
    t.integer "term", null: false, comment: "年度(期)"
    t.index ["chemical_id", "term"], name: "index_chemical_terms_on_chemical_id_and_term", unique: true
  end

  create_table "chemical_types", id: { type: :serial, comment: "薬剤種別マスタ" }, comment: "薬剤種別マスタ", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "display_order", default: 1, null: false, comment: "表示順"
    t.string "name", limit: 20, null: false, comment: "薬剤種別名称"
    t.datetime "updated_at", precision: nil
  end

  create_table "chemical_work_types", id: :serial, force: :cascade do |t|
    t.integer "chemical_term_id", comment: "薬剤利用"
    t.datetime "created_at", precision: nil, null: false
    t.decimal "quantity", precision: 5, scale: 1, default: "0.0", null: false, comment: "使用量"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "work_type_id", comment: "作業分類"
    t.index ["chemical_term_id", "work_type_id"], name: "index_chemical_work_types_on_chemical_term_id_and_work_type_id", unique: true
  end

  create_table "chemicals", id: { type: :serial, comment: "薬剤マスタ" }, comment: "薬剤マスタ", force: :cascade do |t|
    t.boolean "aqueous_flag", default: false, null: false, comment: "水溶フラグ"
    t.decimal "base_quantity", precision: 6, default: "0", null: false, comment: "消費数"
    t.integer "base_unit_id", default: 0, null: false, comment: "基本単位"
    t.decimal "carton_quantity", precision: 6, default: "0", null: false, comment: "購買数"
    t.string "carton_unit", limit: 2, default: "", null: false, comment: "購買単位"
    t.integer "chemical_type_id", null: false, comment: "薬剤種別"
    t.datetime "created_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.string "name", limit: 20, null: false, comment: "薬剤名称"
    t.string "phonetic", limit: 40, default: "", null: false, comment: "薬剤ふりがな"
    t.decimal "stock_quantity", precision: 6, default: "0", null: false, comment: "在庫数"
    t.string "stock_unit", limit: 2, default: "", null: false, comment: "在庫単位"
    t.string "unit", limit: 2, default: "袋", null: false, comment: "単位"
    t.datetime "updated_at", precision: nil
    t.string "url", limit: 255, default: "", null: false, comment: "URL"
    t.index ["deleted_at"], name: "index_chemicals_on_deleted_at"
  end

  create_table "cleaning_cleaning_targets", comment: "清掃対象", force: :cascade do |t|
    t.bigint "cleaning_id", comment: "清掃"
    t.integer "cleaning_target_id", comment: "清掃対象ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cleaning_id"], name: "index_cleaning_cleaning_targets_on_cleaning_id"
  end

  create_table "cleaning_institutions", comment: "清掃施設", force: :cascade do |t|
    t.integer "cleaning_id", null: false, comment: "清掃ID"
    t.datetime "created_at", null: false
    t.integer "institution_id", null: false, comment: "施設ID"
    t.datetime "updated_at", null: false
    t.index ["cleaning_id", "institution_id"], name: "cleaning_institutions_2nd", unique: true
  end

  create_table "cleaning_targets", comment: "清掃種別マスタ", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.string "name", limit: 10, default: "", null: false, comment: "名称"
    t.datetime "updated_at", null: false
  end

  create_table "cleanings", comment: "清掃", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "method", limit: 20, default: "", null: false, comment: "清掃方法"
    t.string "target", limit: 20, default: "", null: false, comment: "駆除対象"
    t.datetime "updated_at", null: false
    t.integer "work_id", null: false, comment: "作業ID"
  end

  create_table "cost_types", comment: "原価種別", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.string "name", limit: 10, null: false, comment: "原価種別名称"
    t.string "phonetic", limit: 20, null: false, comment: "原価種別名称(ふりがな)"
    t.datetime "updated_at", null: false
  end

  create_table "daily_weathers", primary_key: "target_date", id: { type: :date, comment: "対象日" }, comment: "気象", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.float "height", comment: "最高気温"
    t.float "humidity", comment: "湿度"
    t.float "lowest", comment: "最低気温"
    t.float "pressure", comment: "気圧"
    t.float "rain", comment: "降水量"
    t.float "snow", comment: "降雪量"
    t.float "sunshine", comment: "日照時間"
    t.datetime "updated_at", precision: nil, null: false
    t.string "wind_direction", limit: 3, comment: "風向"
    t.float "wind_speed", comment: "風速"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "attempts", default: 0, null: false
    t.datetime "created_at", precision: nil
    t.datetime "failed_at", precision: nil
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "locked_at", precision: nil
    t.string "locked_by"
    t.integer "priority", default: 0, null: false
    t.string "queue"
    t.datetime "run_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "depreciation_types", id: { type: :serial, comment: "減価償却分類" }, comment: "減価償却分類", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "depreciation_id", comment: "減価償却"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "work_type_id", null: false, comment: "作業分類"
    t.index ["depreciation_id", "work_type_id"], name: "index_depreciation_types_on_depreciation_id_and_work_type_id", unique: true
  end

  create_table "depreciations", id: { type: :serial, comment: "減価償却" }, comment: "減価償却", force: :cascade do |t|
    t.decimal "cost", precision: 9, default: "0", null: false, comment: "減価償却費"
    t.datetime "created_at", precision: nil, null: false
    t.integer "machine_id", comment: "機械"
    t.integer "term", null: false, comment: "年度(期)"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["term", "machine_id"], name: "index_depreciations_on_term_and_machine_id", unique: true
  end

  create_table "drying_lands", comment: "乾燥調整場所", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.integer "drying_id", default: 0, null: false, comment: "乾燥調整"
    t.integer "land_id", comment: "作業地"
    t.decimal "percentage", precision: 4, scale: 1, default: "100.0", null: false, comment: "割合"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["drying_id", "display_order"], name: "drying_lands_3rd", unique: true
  end

  create_table "drying_moths", comment: "乾燥籾", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "drying_id", default: 0, null: false, comment: "乾燥調整"
    t.integer "moth_count", default: 0, null: false, comment: "回数"
    t.integer "moth_no", comment: "No."
    t.decimal "moth_weight", precision: 5, scale: 1, comment: "籾(kg)"
    t.decimal "rice_weight", precision: 5, scale: 1, comment: "玄米(kg)"
    t.datetime "updated_at", precision: nil, null: false
    t.decimal "water_content", precision: 3, scale: 1, comment: "水分"
    t.index ["drying_id", "moth_count"], name: "drying_moths_secondary", unique: true
  end

  create_table "dryings", comment: "乾燥", force: :cascade do |t|
    t.date "carried_on", null: false, comment: "搬入日"
    t.integer "copy_flag", limit: 2, default: 0, null: false, comment: "複写フラグ"
    t.datetime "created_at", precision: nil, null: false
    t.integer "drying_type_id", default: 0, null: false, comment: "乾燥種別"
    t.decimal "fixed_amount", precision: 7, comment: "確定額"
    t.integer "home_id", default: 0, null: false, comment: "担当世帯"
    t.date "shipped_on", comment: "出荷日"
    t.integer "term", null: false, comment: "年度(期)"
    t.datetime "updated_at", precision: nil, null: false
    t.decimal "water_content", precision: 3, scale: 1, comment: "水分"
    t.integer "work_type_id", comment: "作業分類"
    t.index ["carried_on", "home_id", "copy_flag"], name: "dryings_secondary", unique: true
  end

  create_table "expense_types", comment: "経費種別", force: :cascade do |t|
    t.boolean "chemical_flag", default: false, null: false, comment: "薬剤フラグ"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil, comment: "削除年月日"
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.string "name", limit: 10, default: "", null: false, comment: "経費種別名称"
    t.boolean "other_flag", default: false, null: false, comment: "その他フラグ"
    t.boolean "sales_flag", default: false, null: false, comment: "売上フラグ"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "expense_work_types", id: { type: :serial, comment: "経費作業種別" }, comment: "経費作業種別", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "expense_id", comment: "経費"
    t.decimal "rate", precision: 5, scale: 2, default: "0.0", null: false, comment: "割合"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "work_type_id", comment: "作業分類"
    t.index ["expense_id", "work_type_id"], name: "index_expense_work_types_on_expense_id_and_work_type_id", unique: true
  end

  create_table "expenses", id: { type: :serial, comment: "経費" }, comment: "経費", force: :cascade do |t|
    t.decimal "amount", precision: 7, default: "0", null: false, comment: "支払金額"
    t.integer "chemical_id", comment: "薬剤"
    t.integer "chemical_type_id", default: 0, comment: "薬剤種別"
    t.string "content", limit: 40, comment: "支払内容"
    t.boolean "cost_flag", default: false, null: false, comment: "支払時原価フラグ"
    t.datetime "created_at", precision: nil, null: false
    t.decimal "discount", precision: 7, comment: "割引額"
    t.decimal "discount_denom", precision: 7, comment: "割引率(分母)"
    t.decimal "discount_numor", precision: 7, comment: "割引率(分子)"
    t.integer "expense_type_id", default: 0, null: false, comment: "経費種別"
    t.date "payed_on", null: false, comment: "支払日"
    t.decimal "quantity", precision: 4, comment: "数量"
    t.integer "term", null: false, comment: "年度(期)"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "fixes", primary_key: ["term", "fixed_at"], comment: "確定データ", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.date "fixed_at", null: false, comment: "確定日"
    t.integer "fixed_by", comment: "確定者"
    t.integer "hours", null: false, comment: "合計作業工数"
    t.decimal "machines_amount", precision: 8, null: false, comment: "合計機械利用料"
    t.integer "term", default: 0, null: false, comment: "年度(期)"
    t.datetime "updated_at", precision: nil, null: false
    t.decimal "works_amount", precision: 8, null: false, comment: "合計作業日当"
    t.integer "works_count", null: false, comment: "合計作業数"
  end

  create_table "healths", comment: "健康", force: :cascade do |t|
    t.string "code", limit: 1, null: false, comment: "コード"
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.string "name", limit: 10, null: false, comment: "原価種別名称"
    t.boolean "other_flag", default: false, null: false, comment: "その他フラグ"
    t.datetime "updated_at", null: false
    t.boolean "well_flag", default: false, null: false, comment: "健康フラグ"
  end

  create_table "homes", id: { type: :serial, comment: "世帯マスタ" }, comment: "世帯マスタ", force: :cascade do |t|
    t.string "address1", limit: 50, comment: "住所1"
    t.string "address2", limit: 50, comment: "住所2"
    t.boolean "company_flag", default: false, null: false, comment: "営農組合フラグ"
    t.datetime "created_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.integer "display_order", comment: "表示順"
    t.integer "drying_order", comment: "出力順(乾燥調整用)"
    t.string "fax", limit: 15, comment: "FAX番号"
    t.integer "finance_order", comment: "出力順(会計用)"
    t.point "location", comment: "位置"
    t.boolean "member_flag", default: true, null: false, comment: "組合員フラグ"
    t.string "name", limit: 10, comment: "世帯名"
    t.integer "owned_rice_order", comment: "出力順(保有米)"
    t.boolean "owner_flag", default: false, null: false, comment: "所有者フラグ"
    t.string "phonetic", limit: 15, comment: "世帯名(よみ)"
    t.integer "section_id", comment: "班／町内"
    t.integer "seedling_order", comment: "出力順(育苗用)"
    t.string "telephone", limit: 15, comment: "電話番号"
    t.datetime "updated_at", precision: nil
    t.integer "worker_id", comment: "世帯主(代表者)"
    t.boolean "worker_payment_flag", default: false, null: false, comment: "個人支払フラグ"
    t.string "zip_code", limit: 7, comment: "郵便番号"
    t.index ["deleted_at"], name: "index_homes_on_deleted_at"
  end

  create_table "institutions", comment: "施設マスタ", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "display_order", null: false, comment: "表示順"
    t.integer "end_term", default: 9999, null: false, comment: "稼動終了年度"
    t.point "location", comment: "位置"
    t.string "name", limit: 40, null: false, comment: "施設名称"
    t.integer "start_term", default: 0, null: false, comment: "稼動開始年度"
    t.datetime "updated_at", null: false
  end

  create_table "ip_lists", comment: "IPアドレスリスト", force: :cascade do |t|
    t.integer "block_count", default: 0, null: false, comment: "ブロック回数"
    t.datetime "confirmation_expired_at", comment: "確認有効期限"
    t.datetime "created_at", null: false
    t.integer "created_by", default: 0, null: false, comment: "作成者"
    t.date "expired_on", comment: "有効期限"
    t.string "hashed_token", limit: 64, default: "", null: false, comment: "ハッシュ化トークン"
    t.string "ip_address", limit: 64, default: "", null: false, comment: "IP Address"
    t.string "mail", limit: 255, default: "", null: false, comment: "メールアドレス"
    t.datetime "updated_at", null: false
    t.boolean "white_flag", default: false, null: false, comment: "ホワイトリストフラグ"
    t.index ["ip_address"], name: "ixdex_ip_lists_on_ip_address", unique: true
  end

  create_table "land_costs", id: { type: :serial, comment: "土地原価" }, comment: "土地原価", force: :cascade do |t|
    t.date "activated_on", default: "1900-01-01", null: false, comment: "有効日"
    t.datetime "created_at", precision: nil, null: false
    t.integer "land_id", null: false, comment: "土地"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "work_type_id", null: false, comment: "作業分類"
    t.index ["activated_on", "land_id"], name: "index_land_costs_on_activated_on_and_land_id", unique: true
  end

  create_table "land_fees", comment: "土地料金", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "land_id", null: false, comment: "土地"
    t.decimal "manage_fee", precision: 7, scale: 1, default: "0.0", null: false, comment: "管理料"
    t.decimal "peasant_fee", precision: 7, scale: 1, default: "0.0", null: false, comment: "小作料"
    t.integer "term", null: false, comment: "年度(期)"
    t.datetime "updated_at", null: false
    t.index ["term", "land_id"], name: "land_fees_2nd", unique: true
  end

  create_table "land_homes", comment: "土地管理", force: :cascade do |t|
    t.decimal "area", precision: 5, scale: 2, null: false, comment: "面積"
    t.datetime "created_at", null: false
    t.integer "home_id", comment: "世帯"
    t.integer "land_id", null: false, comment: "土地"
    t.boolean "manager_flag", comment: "管理者フラグ"
    t.boolean "owner_flag", comment: "所有者フラグ"
    t.string "place", limit: 15, null: false, comment: "番地"
    t.datetime "updated_at", null: false
  end

  create_table "land_places", id: { type: :serial, comment: "場所マスタ" }, comment: "場所マスタ", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.integer "display_order", comment: "表示順"
    t.string "name", limit: 40, null: false, comment: "場所名称"
    t.text "remarks", comment: "備考"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "lands", id: { type: :serial, comment: "土地マスタ" }, comment: "土地マスタ", force: :cascade do |t|
    t.decimal "area", precision: 5, scale: 2, null: false, comment: "面積(α)"
    t.string "broccoli_mark", limit: 1, comment: "ブロッコリ記号"
    t.datetime "created_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.integer "display_order", comment: "表示順"
    t.date "end_on", default: "2999-12-31", null: false, comment: "有効期間(至)"
    t.boolean "group_flag", default: false, null: false, comment: "グループフラグ"
    t.integer "group_id", comment: "グループID"
    t.integer "group_order", default: 0, null: false, comment: "グループ内並び順"
    t.integer "land_place_id", comment: "土地"
    t.integer "manager_id", comment: "管理者"
    t.integer "owner_id", comment: "所有者"
    t.integer "parcel_number", comment: "耕地番号"
    t.integer "peasant_end_term", default: 9999, null: false, comment: "小作料期間(至)"
    t.integer "peasant_start_term", default: 0, null: false, comment: "小作料期間(自)"
    t.string "place", limit: 15, null: false, comment: "番地"
    t.decimal "reg_area", precision: 5, scale: 2, comment: "登記面積"
    t.polygon "region", comment: "領域"
    t.date "start_on", default: "1900-01-01", null: false, comment: "有効期間(自)"
    t.boolean "target_flag", default: true, null: false, comment: "管理対象フラグ"
    t.datetime "updated_at", precision: nil
    t.string "uuid", limit: 36, default: "", null: false, comment: "UUID"
    t.index ["deleted_at"], name: "index_lands_on_deleted_at"
    t.index ["place"], name: "index_lands_on_place"
    t.index ["uuid"], name: "index_lands_on_uuid", unique: true, where: "((uuid)::text <> ''::text)"
  end

  create_table "machine_kinds", id: { type: :serial, comment: "作業種別機械利用可能マスタ" }, comment: "作業種別機械利用可能マスタ", force: :cascade do |t|
    t.integer "machine_type_id", null: false, comment: "機械種別"
    t.integer "work_kind_id", null: false, comment: "作業種別"
    t.index ["machine_type_id", "work_kind_id"], name: "machine_kinds_2nd_key", unique: true
  end

  create_table "machine_price_details", id: { type: :serial, comment: "機械利用単価マスタ(明細)" }, comment: "機械利用単価マスタ(明細)", force: :cascade do |t|
    t.integer "adjust_id", comment: "単位"
    t.datetime "created_at", precision: nil, null: false
    t.integer "lease_id", null: false, comment: "リース"
    t.integer "machine_price_header_id", null: false, comment: "単価ヘッダ"
    t.decimal "price", precision: 5, default: "0", null: false, comment: "単価"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "work_kind_id", default: 0, null: false, comment: "作業種別"
    t.index ["machine_price_header_id", "lease_id", "work_kind_id"], name: "machine_price_details_2nd_key", unique: true
  end

  create_table "machine_price_headers", id: { type: :serial, comment: "機械利用単価マスタ(ヘッダ)" }, comment: "機械利用単価マスタ(ヘッダ)", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "machine_id", default: 0, null: false, comment: "機械"
    t.integer "machine_type_id", default: 0, null: false, comment: "機械種別"
    t.datetime "updated_at", precision: nil, null: false
    t.date "validated_at", null: false, comment: "起点日"
    t.index ["validated_at", "machine_id", "machine_type_id"], name: "machine_price_headers_2nd_key", unique: true
  end

  create_table "machine_remarks", comment: "作業機械備考", force: :cascade do |t|
    t.string "care_remarks", limit: 30, default: "", null: false, comment: "備考(保守)"
    t.datetime "created_at", null: false
    t.string "danger_remarks", limit: 30, default: "", null: false, comment: "備考(危険)"
    t.integer "machine_id", null: false, comment: "機械"
    t.string "other_remarks", limit: 30, default: "", null: false, comment: "備考"
    t.datetime "updated_at", null: false
    t.integer "work_id", null: false, comment: "作業"
    t.index ["work_id", "machine_id"], name: "machine_remarks_2nd", unique: true
  end

  create_table "machine_results", id: { type: :serial, comment: "機械稼動データ" }, comment: "機械稼動データ", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "display_order", default: 1, null: false, comment: "表示順"
    t.integer "fixed_adjust_id", comment: "確定稼動単位"
    t.decimal "fixed_amount", precision: 7, comment: "確定使用料"
    t.decimal "fixed_price", precision: 5, comment: "確定稼動単価"
    t.decimal "fixed_quantity", precision: 6, scale: 2, comment: "確定稼動量"
    t.decimal "fuel_usage", precision: 5, scale: 2, default: "0.0", null: false, comment: "燃料使用量"
    t.decimal "hours", precision: 3, scale: 1, default: "0.0", null: false, comment: "稼動時間"
    t.integer "machine_id", comment: "機械"
    t.datetime "updated_at", precision: nil
    t.integer "work_result_id", comment: "作業結果データ"
    t.index ["machine_id", "work_result_id"], name: "index_machine_results_on_machine_id_and_work_result_id", unique: true
  end

  create_table "machine_types", id: { type: :serial, comment: "機械種別マスタ" }, comment: "機械種別マスタ", force: :cascade do |t|
    t.string "code", limit: 1, default: "", null: false, comment: "種別コード"
    t.datetime "created_at", precision: nil
    t.integer "display_order", default: 1, null: false, comment: "表示順"
    t.string "name", limit: 10, null: false, comment: "機械種別名称"
    t.datetime "updated_at", precision: nil
  end

  create_table "machines", id: { type: :serial, comment: "機械マスタ" }, comment: "機械マスタ", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.boolean "diesel_flag", default: false, null: false, comment: "ディーゼル"
    t.integer "display_order", null: false, comment: "表示順"
    t.integer "home_id", default: 0, null: false, comment: "所有者"
    t.integer "machine_type_id", default: 0, null: false, comment: "機械種別"
    t.string "name", limit: 40, null: false, comment: "機械名称"
    t.integer "number", comment: "番号"
    t.datetime "updated_at", precision: nil
    t.date "validity_end_at", comment: "稼動終了(予定)日"
    t.date "validity_start_at", comment: "稼動開始日"
  end

  create_table "minutes", comment: "議事録", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.binary "pdf", comment: "PDF"
    t.string "pdf_name", limit: 50, comment: "PDFファイル名"
    t.integer "schedule_id", default: 0, null: false, comment: "作業予定"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["schedule_id"], name: "index_minutes_on_schedule_id", unique: true
  end

  create_table "organizations", id: { type: :serial, comment: "組織(体系)マスタ" }, comment: "組織(体系)マスタ", force: :cascade do |t|
    t.integer "broccoli_work_kind_id", comment: "ブロッコリ種別分類"
    t.integer "broccoli_work_type_id", comment: "ブロッコリ作業分類"
    t.integer "chemical_group_count", default: 1, comment: "薬剤グループ数"
    t.integer "chemicals_count", default: 4, null: false, comment: "作業日報の薬剤数"
    t.integer "cleaning_id", comment: "清掃id"
    t.string "consignor_code", limit: 10, comment: "委託者コード"
    t.string "consignor_name", limit: 40, comment: "委託者コード"
    t.integer "contract_work_type_id", comment: "受託作業分類"
    t.datetime "created_at", precision: nil
    t.integer "daily_worker", limit: 2, default: 0, null: false, comment: "作業日報の作業者名付加情報"
    t.integer "harvesting_work_kind_id", comment: "稲刈作業種別"
    t.integer "lands_count", default: 17, null: false, comment: "作業日報の土地数"
    t.point "location", default: [35.0, 135.0], null: false, comment: "位置"
    t.integer "machines_count", default: 8, null: false, comment: "作業日報の機械数"
    t.integer "maintenance_id", comment: "機械保守id"
    t.string "name", limit: 20, null: false, comment: "組織名称"
    t.integer "rice_planting_id", comment: "田植作業種別"
    t.integer "straw_id", comment: "稲わらid"
    t.integer "term", default: 0, null: false, comment: "現在の年度(期)"
    t.integer "training_id", comment: "訓練id"
    t.datetime "updated_at", precision: nil
    t.string "url", comment: "URL"
    t.integer "whole_crop_work_kind_id", comment: "WCS収穫分類"
    t.integer "workers_count", default: 12, null: false, comment: "作業日報の作業者数"
  end

  create_table "owned_rice_prices", comment: "保有米単価", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.string "name", limit: 10, default: "", null: false, comment: "品種名"
    t.decimal "owned_price", precision: 5, default: "0", null: false, comment: "保有米価格"
    t.string "short_name", limit: 5, default: "", null: false, comment: "品種名(略称)"
    t.integer "term", null: false, comment: "年度(期)"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "work_type_id", default: 0, null: false, comment: "品種"
    t.index ["term", "work_type_id"], name: "owned_rice_prices_2nd", unique: true
  end

  create_table "owned_rices", comment: "保有米", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "home_id", default: 0, null: false, comment: "購入世帯"
    t.decimal "owned_count", precision: 3, default: "0", null: false, comment: "保有米数"
    t.integer "owned_rice_price_id", default: 0, null: false, comment: "保有米単価"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["home_id", "owned_rice_price_id"], name: "owned_rices_2nd", unique: true
  end

  create_table "plan_lands", id: false, comment: "作付計画", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "land_id", null: false, comment: "土地"
    t.integer "term", default: 0, null: false, comment: "年度"
    t.datetime "updated_at", null: false
    t.integer "user_id", default: 0, null: false, comment: "利用者"
    t.integer "work_type_id", null: false, comment: "作業分類"
    t.index ["user_id", "land_id", "term"], name: "plan_lands_2nd", unique: true
  end

  create_table "plan_seedlings", comment: "育苗計画", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "home_id", comment: "世帯"
    t.integer "plan_work_type_id", null: false, comment: "作業計画"
    t.decimal "quantity", precision: 4, default: "0", null: false, comment: "枚数"
    t.datetime "updated_at", null: false
    t.index ["plan_work_type_id", "home_id"], name: "plan_seedlings_2nd", unique: true
  end

  create_table "plan_work_types", comment: "作業計画", force: :cascade do |t|
    t.decimal "area", precision: 7, scale: 2, default: "0.0", null: false, comment: "面積(α)"
    t.decimal "bag_weight1", precision: 3, scale: 1, default: "0.0", null: false, comment: "大袋(kg)"
    t.decimal "bag_weight2", precision: 3, scale: 1, default: "0.0", null: false, comment: "小袋(kg)"
    t.decimal "between_stocks", precision: 2, default: "0", null: false, comment: "株間(cm)"
    t.datetime "created_at", null: false
    t.integer "month", default: 0, null: false, comment: "開始月"
    t.decimal "quantity", precision: 5, default: "0", null: false, comment: "枚数"
    t.decimal "seeds", precision: 3, default: "0", null: false, comment: "種子(1枚当g)"
    t.decimal "soils", precision: 4, scale: 2, default: "0.0", null: false, comment: "育苗土(1枚当袋)"
    t.decimal "unit", precision: 3, scale: 1, default: "0.0", null: false, comment: "枚数(10a当)"
    t.datetime "updated_at", null: false
    t.integer "work_type_id", null: false, comment: "作業分類"
    t.index ["work_type_id"], name: "plan_work_types_2nd", unique: true
  end

  create_table "schedule_workers", id: { type: :serial, comment: "作業予定作業者" }, comment: "作業予定作業者", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.integer "schedule_id", comment: "作業予定"
    t.datetime "updated_at", precision: nil, null: false
    t.string "uuid", limit: 36, comment: "UUID(カレンダー用)"
    t.integer "worker_id", comment: "作業者"
    t.index ["schedule_id", "worker_id"], name: "index_schedule_workers_on_schedule_id_and_worker_id", unique: true
  end

  create_table "schedules", id: { type: :serial, comment: "作業予定" }, comment: "作業予定", force: :cascade do |t|
    t.boolean "calendar_remove_flag", default: false, null: false, comment: "カレンダー削除フラグ"
    t.datetime "created_at", precision: nil, null: false
    t.integer "created_by", default: 0, null: false, comment: "作成者ID"
    t.time "end_at", default: "2000-01-01 17:00:00", null: false, comment: "終了予定時刻"
    t.boolean "farming_flag", default: true, null: false, comment: "営農フラグ"
    t.boolean "line_flag", default: true, null: false, comment: "LINEフラグ"
    t.boolean "minutes_flag", default: true, null: false, comment: "議事録フラグ"
    t.string "name", limit: 40, null: false, comment: "作業名称"
    t.time "start_at", default: "2000-01-01 08:00:00", null: false, comment: "開始予定時刻"
    t.integer "term", null: false, comment: "年度(期)"
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "work_flag", default: true, null: false, comment: "作業フラグ"
    t.integer "work_kind_id", default: 0, null: false, comment: "作業種別"
    t.integer "work_type_id", comment: "作業分類"
    t.date "worked_at", null: false, comment: "作業予定日"
  end

  create_table "sections", id: { type: :serial, comment: "班／町内マスタ" }, comment: "班／町内マスタ", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.integer "display_order", default: 1, null: false, comment: "表示順"
    t.string "name", limit: 40, null: false, comment: "班名称"
    t.datetime "updated_at", precision: nil
    t.boolean "work_flag", default: true, null: false, comment: "作業班フラグ"
    t.index ["deleted_at"], name: "index_sections_on_deleted_at"
  end

  create_table "seedling_homes", id: { type: :serial, comment: "育苗担当世帯" }, comment: "育苗担当世帯", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "home_id", comment: "世帯"
    t.decimal "quantity", precision: 4, default: "0", null: false, comment: "苗箱数"
    t.integer "seedling_id", comment: "育苗"
    t.date "sowed_on", comment: "播種日"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "seedling_results", id: { type: :serial, comment: "育苗結果" }, comment: "育苗結果", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.boolean "disposal_flag", default: false, null: false, comment: "廃棄フラグ"
    t.decimal "quantity", precision: 3, default: "0", null: false, comment: "苗箱数"
    t.integer "seedling_home_id", comment: "育苗担当"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "work_result_id", comment: "作業結果"
  end

  create_table "seedlings", id: { type: :serial, comment: "育苗" }, comment: "育苗", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.decimal "seed_cost", precision: 6, default: "0", null: false, comment: "種子原価"
    t.decimal "soil_quantity", precision: 4, default: "0", null: false, comment: "育苗土数"
    t.integer "term", null: false, comment: "年度(期)"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "work_type_id", comment: "作業分類"
    t.index ["term", "work_type_id"], name: "index_seedlings_on_term_and_work_type_id", unique: true
  end

  create_table "sorimachi_accounts", comment: "ソリマチ勘定科目", force: :cascade do |t|
    t.integer "auto_code", comment: "自動設定コード"
    t.integer "auto_work_type_id", comment: "自動設定作業分類"
    t.integer "code", default: 0, null: false, comment: "科目コード"
    t.boolean "cost_flag", default: false, null: false, comment: "原価計上フラグ"
    t.datetime "created_at", null: false
    t.string "name", limit: 10, default: "", null: false, comment: "名称"
    t.integer "term", null: false, comment: "年度(期)"
    t.integer "total_cost_type_id", default: 0, null: false, comment: "原価種別"
    t.datetime "updated_at", null: false
    t.index ["term", "code"], name: "sorimachi_accounts_2nd", unique: true
  end

  create_table "sorimachi_journals", comment: "ソリマチ仕訳", force: :cascade do |t|
    t.date "accounted_on", comment: "仕訳日"
    t.decimal "amount1", precision: 11, scale: 2, default: "0.0", null: false, comment: "金額1"
    t.decimal "amount2", precision: 11, scale: 2, default: "0.0", null: false, comment: "金額2"
    t.decimal "amount3", precision: 11, scale: 2, default: "0.0", null: false, comment: "金額3"
    t.integer "code01", null: false, comment: "コード0-1"
    t.integer "code02", null: false, comment: "コード0-2"
    t.integer "code03", null: false, comment: "コード0-3"
    t.integer "code04", null: false, comment: "コード0-4"
    t.integer "code05", null: false, comment: "コード0-5"
    t.integer "code06", null: false, comment: "コード0-6"
    t.integer "code07", null: false, comment: "コード0-7"
    t.integer "code11", null: false, comment: "コード1-1"
    t.integer "code12", null: false, comment: "コード1-2"
    t.integer "code13", null: false, comment: "コード1-3"
    t.integer "code14", null: false, comment: "コード1-4"
    t.integer "code15", null: false, comment: "コード1-5"
    t.integer "code16", null: false, comment: "コード1-6"
    t.integer "code17", null: false, comment: "コード1-7"
    t.integer "code18", null: false, comment: "コード1-8"
    t.integer "code21", limit: 2, null: false, comment: "コード2-1"
    t.string "code31", limit: 1, null: false, comment: "コード3-1"
    t.boolean "cost0_flag", default: false, null: false, comment: "原価フラグ(借方)"
    t.boolean "cost1_flag", default: false, null: false, comment: "原価フラグ(貸方)"
    t.datetime "created_at", null: false
    t.integer "detail", null: false, comment: "明細番号"
    t.integer "line", null: false, comment: "行番号"
    t.string "remark1", limit: 50, null: false, comment: "備考1"
    t.string "remark2", limit: 50, null: false, comment: "備考2"
    t.string "remark3", limit: 50, null: false, comment: "備考3"
    t.string "remark4", limit: 50, null: false, comment: "備考4"
    t.integer "tax01", comment: "消費税0-1"
    t.integer "tax11", comment: "消費税1-1"
    t.integer "term", null: false, comment: "年度(期)"
    t.datetime "updated_at", null: false
    t.index ["term", "line", "detail"], name: "sorimachi_journals_2nd", unique: true
  end

  create_table "sorimachi_work_types", comment: "ソリマチ作業分類", force: :cascade do |t|
    t.decimal "amount", precision: 7, default: "0", null: false, comment: "内訳金額"
    t.datetime "created_at", null: false
    t.integer "sorimachi_journal_id", default: 0, null: false, comment: "ソリマチ仕訳"
    t.datetime "updated_at", null: false
    t.integer "work_type_id", default: 0, null: false, comment: "作業分類"
    t.index ["sorimachi_journal_id", "work_type_id"], name: "sorimachi_work_types_2nd", unique: true
  end

  create_table "systems", id: { type: :serial, comment: "システムマスタ" }, comment: "システムマスタ", force: :cascade do |t|
    t.decimal "adjust_price", precision: 4, default: "0", null: false, comment: "基準額(調整のみ)"
    t.datetime "created_at", precision: nil
    t.decimal "default_fee", precision: 6, default: "15000", null: false, comment: "初期値(管理料)"
    t.decimal "default_price", precision: 5, default: "1000", null: false, comment: "初期値(工賃)"
    t.decimal "dry_adjust_price", precision: 4, default: "0", null: false, comment: "基準額(乾燥調整)"
    t.decimal "dry_price", precision: 4, default: "0", null: false, comment: "基準額(乾燥のみ)"
    t.date "end_date", null: false, comment: "期末日"
    t.boolean "half_sum_flag", default: false, null: false, comment: "半端米集計フラグ"
    t.decimal "light_oil_price", precision: 4, default: "0", null: false, comment: "軽油価格"
    t.integer "organization_id", default: 0, null: false, comment: "組織"
    t.decimal "relative_price", precision: 5, default: "0", null: false, comment: "縁故米加算額"
    t.integer "seedling_chemical_id", default: 0, comment: "育苗土"
    t.decimal "seedling_price", precision: 4, default: "0", null: false, comment: "育苗費"
    t.date "start_date", null: false, comment: "期首日"
    t.date "target_from", comment: "開始年月"
    t.date "target_to", comment: "終了年月"
    t.integer "term", null: false, comment: "年度(期)"
    t.datetime "updated_at", precision: nil
    t.decimal "waste_adjust_price", precision: 4, default: "0", null: false, comment: "くず米金額(調整)"
    t.decimal "waste_drying_price", precision: 4, default: "0", null: false, comment: "くず米金額(乾燥)"
    t.decimal "waste_price", precision: 4, default: "0", null: false, comment: "くず米金額"
    t.index ["term", "organization_id"], name: "index_systems_on_term_and_organization_id", unique: true
  end

  create_table "task_comments", comment: "タスクコメント", force: :cascade do |t|
    t.text "body", default: "", null: false, comment: "コメント本文"
    t.datetime "created_at", null: false
    t.bigint "poster_id", null: false, comment: "投稿者ID"
    t.bigint "task_id", null: false, comment: "対象タスクID"
    t.datetime "updated_at", null: false
    t.index ["poster_id"], name: "index_task_comments_on_poster_id"
    t.index ["task_id", "created_at"], name: "index_task_comments_on_task_id_and_created_at"
    t.index ["task_id", "poster_id", "updated_at"], name: "index_task_comments_on_task_id_and_poster_id_and_updated_at"
    t.index ["task_id", "updated_at"], name: "index_task_comments_on_task_id_and_updated_at"
    t.index ["task_id"], name: "index_task_comments_on_task_id"
  end

  create_table "task_events", comment: "タスクイベント", force: :cascade do |t|
    t.bigint "actor_id", null: false, comment: "実行者"
    t.bigint "assignee_from_id", comment: "変更前の担当者ID"
    t.bigint "assignee_to_id", comment: "変更後の担当者ID"
    t.datetime "created_at", null: false
    t.date "due_on_from", comment: "変更前の期限"
    t.date "due_on_to", comment: "変更後の期限"
    t.integer "event_type", null: false, comment: "イベント種別"
    t.integer "source", default: 0, null: false, comment: "ソース"
    t.integer "status_from_id", comment: "変更前ステータス"
    t.integer "status_to_id", comment: "変更後ステータス"
    t.bigint "task_comment_id", comment: "関連コメントID"
    t.bigint "task_id", null: false, comment: "対象タスクID"
    t.datetime "updated_at", null: false
    t.bigint "work_id", comment: "関連作業ID"
    t.index ["actor_id"], name: "index_task_events_on_actor_id"
    t.index ["assignee_from_id"], name: "index_task_events_on_assignee_from_id"
    t.index ["assignee_to_id"], name: "index_task_events_on_assignee_to_id"
    t.index ["task_comment_id"], name: "index_task_events_on_task_comment_id"
    t.index ["task_id", "actor_id", "updated_at"], name: "index_task_events_on_task_id_and_actor_id_and_updated_at"
    t.index ["task_id", "created_at"], name: "index_task_events_on_task_id_and_created_at"
    t.index ["task_id", "updated_at"], name: "index_task_events_on_task_id_and_updated_at"
    t.index ["task_id"], name: "index_task_events_on_task_id"
    t.index ["work_id"], name: "index_task_events_on_work_id"
  end

  create_table "task_reads", comment: "タスク既読", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "last_read_at", default: "1970-01-01 00:00:00", null: false, comment: "最終既読日時"
    t.bigint "task_id", null: false, comment: "タスクID"
    t.datetime "updated_at", null: false
    t.bigint "worker_id", null: false, comment: "作業者ID"
    t.index ["task_id", "worker_id"], name: "index_task_reads_on_task_id_and_worker_id", unique: true
    t.index ["task_id"], name: "index_task_reads_on_task_id"
    t.index ["worker_id"], name: "index_task_reads_on_worker_id"
  end

  create_table "task_templates", comment: "定型タスク", force: :cascade do |t|
    t.boolean "active", default: true, null: false, comment: "有効"
    t.integer "annual_month", comment: "期日月"
    t.datetime "created_at", null: false
    t.text "description", default: "", null: false, comment: "説明"
    t.datetime "discarded_at", comment: "論理削除日時"
    t.integer "kind", default: 0, null: false, comment: "年次/月次"
    t.integer "monthly_stage", default: 0, comment: "期日週"
    t.integer "months_before_due", default: 1, comment: "事前通知月数"
    t.integer "office_role", default: 0, null: false, comment: "役割"
    t.integer "offset", default: 0, comment: "基準からのズレ"
    t.bigint "organization_id", null: false, comment: "組織ID"
    t.integer "priority", default: 0, null: false, comment: "優先度"
    t.string "title", limit: 40, null: false, comment: "タスク名"
    t.datetime "updated_at", null: false
    t.index ["kind", "annual_month", "monthly_stage"], name: "idx_on_kind_annual_month_monthly_stage_5eb8d135fc"
    t.index ["organization_id"], name: "index_task_templates_on_organization_id"
  end

  create_table "task_watchers", comment: "タスク閲覧者", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "task_id", null: false, comment: "タスクID"
    t.datetime "updated_at", null: false
    t.bigint "worker_id", null: false, comment: "閲覧者ID"
    t.index ["task_id"], name: "index_task_watchers_on_task_id"
    t.index ["worker_id", "task_id"], name: "index_task_watchers_on_worker_id_and_task_id", unique: true
    t.index ["worker_id"], name: "index_task_watchers_on_worker_id"
  end

  create_table "tasks", comment: "タスク", force: :cascade do |t|
    t.bigint "assignee_id", comment: "担当者"
    t.datetime "created_at", null: false
    t.bigint "creator_id", comment: "作成者"
    t.text "description", default: "", null: false, comment: "説明"
    t.date "due_on", comment: "期限"
    t.integer "end_reason", default: 0, null: false, comment: "完了理由"
    t.date "ended_on", comment: "完了日"
    t.integer "kanban_position", default: 0, null: false, comment: "カンバンの位置"
    t.integer "office_role", default: 0, null: false, comment: "役割"
    t.date "planned_start_on", default: "1900-01-01", null: false, comment: "開始予定日"
    t.integer "priority", default: 0, null: false, comment: "優先度"
    t.date "started_on", comment: "着手日"
    t.integer "task_status_id", default: 0, null: false, comment: "状態"
    t.bigint "task_template_id", comment: "定型タスクID"
    t.string "title", limit: 64, default: "", null: false, comment: "タスク名"
    t.datetime "updated_at", null: false
    t.index ["assignee_id"], name: "index_tasks_on_assignee_id"
    t.index ["creator_id"], name: "index_tasks_on_creator_id"
    t.index ["task_status_id", "kanban_position"], name: "index_tasks_on_task_status_id_and_kanban_position"
    t.index ["task_template_id"], name: "index_tasks_on_task_template_id"
  end

  create_table "topics", comment: "トピック", force: :cascade do |t|
    t.text "content", comment: "内容"
    t.datetime "created_at", null: false
    t.date "posted_on", null: false, comment: "投稿日"
    t.string "title", limit: 512, default: "", null: false, comment: "タイトル"
    t.integer "topic_type_id", default: 0, null: false, comment: "トピック種別"
    t.datetime "updated_at", null: false
    t.string "url", limit: 512, default: "", null: false, comment: "URL"
    t.index "((((COALESCE(title, ''::character varying))::text || ' '::text) || COALESCE(content, ''::text)))", name: "index_topics_on_title_and_content_pgroonga", using: :pgroonga
    t.index ["url"], name: "index_topics_on_url", unique: true
  end

  create_table "total_cost_details", comment: "集計原価(明細)", force: :cascade do |t|
    t.decimal "area", precision: 7, scale: 2, null: false, comment: "面積(α)"
    t.decimal "base_cost", precision: 9, scale: 3, comment: "原価(10α当)"
    t.decimal "cost", precision: 9, comment: "原価"
    t.datetime "created_at", precision: nil, null: false
    t.decimal "rate", precision: 6, scale: 2, default: "1.0", null: false, comment: "割合"
    t.integer "total_cost_id", null: false, comment: "集計原価"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "work_type_id", null: false, comment: "作業分類"
    t.index ["total_cost_id", "work_type_id"], name: "index_total_cost_details_on_total_cost_id_and_work_type_id", unique: true
  end

  create_table "total_costs", comment: "集計原価", force: :cascade do |t|
    t.decimal "amount", precision: 9, default: -> { "(0)::numeric" }, null: false, comment: "原価額"
    t.integer "cost_type_id", comment: "原価種別"
    t.datetime "created_at", precision: nil, null: false
    t.integer "depreciation_id", comment: "減価償却"
    t.integer "display_order", default: 0, null: false, comment: "並び順"
    t.boolean "fiscal_flag", default: false, null: false, comment: "決算期フラグ"
    t.integer "land_id", comment: "土地"
    t.integer "machine_id", comment: "機械"
    t.boolean "member_flag", default: false, null: false, comment: "組合員支払フラグ"
    t.date "occurred_on", null: false, comment: "発生日"
    t.integer "seedling_home_id", comment: "育苗担当"
    t.integer "sorimachi_account_id", comment: "ソリマチ勘定科目"
    t.integer "sorimachi_journal_id", comment: "ソリマチ仕訳"
    t.integer "term", null: false, comment: "年度(期)"
    t.integer "total_cost_type_id", null: false, comment: "集計原価種別"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "whole_crop_land_id", comment: "WCS土地"
    t.integer "work_chemical_id", comment: "薬剤使用"
    t.integer "work_id", comment: "作業"
    t.index ["term", "occurred_on"], name: "index_total_costs_on_term_and_occurred_on"
  end

  create_table "training_training_types", comment: "訓練訓練種別", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "training_id", null: false, comment: "訓練ID"
    t.integer "training_type_id", null: false, comment: "訓練訓練ID"
    t.datetime "updated_at", null: false
    t.index ["training_id", "training_type_id"], name: "training_training_types_2nd", unique: true
  end

  create_table "training_types", comment: "訓練種別", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "display_order", null: false, comment: "表示順"
    t.string "name", limit: 10, null: false, comment: "名称"
    t.boolean "other_flag", default: false, null: false, comment: "その他フラグ"
    t.string "short_name", limit: 2, null: false, comment: "名称(略称)"
    t.datetime "updated_at", null: false
  end

  create_table "trainings", comment: "訓練", force: :cascade do |t|
    t.string "content", limit: 20, default: "", null: false, comment: "内容"
    t.datetime "created_at", null: false
    t.string "document", limit: 40, default: "", null: false, comment: "資料"
    t.text "remarks", default: "", null: false, comment: "備考"
    t.integer "schedule_id", comment: "訓練ID"
    t.string "studying_place", limit: 20, default: "", null: false, comment: "学習場所"
    t.string "training_place", limit: 20, default: "", null: false, comment: "研修場所"
    t.datetime "updated_at", null: false
    t.integer "work_id", null: false, comment: "作業ID"
    t.integer "worker_id", comment: "講師(作業者ID)"
  end

  create_table "user_topics", comment: "利用者トピック", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "line_flag", default: false, null: false, comment: "LINEフラグ"
    t.boolean "pc_flag", default: true, null: false, comment: "パソコンフラグ"
    t.boolean "read_flag", default: false, null: false, comment: "既読フラグ"
    t.boolean "sp_flag", default: true, null: false, comment: "スマートフォンフラグ"
    t.integer "topic_id", null: false, comment: "トピックID"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false, comment: "利用者ID"
    t.string "word", limit: 128, default: "", null: false, comment: "ワード"
    t.index ["user_id", "topic_id"], name: "ix_user_topics_user_id_topic_id", unique: true
  end

  create_table "user_words", comment: "利用者ワード", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "line_flag", default: false, null: false, comment: "LINEフラグ"
    t.boolean "pc_flag", default: true, null: false, comment: "パソコンフラグ"
    t.boolean "sp_flag", default: true, null: false, comment: "スマートフォンフラグ"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false, comment: "利用者ID"
    t.string "word", limit: 128, default: "", null: false, comment: "ワード"
    t.index ["user_id", "word"], name: "index_user_words_on_word_by_user_id", unique: true
    t.index ["word"], name: "index_user_words_on_word"
  end

  create_table "users", id: { type: :serial, comment: "利用者マスタ" }, comment: "利用者マスタ", force: :cascade do |t|
    t.integer "calendar_term", default: 2018, null: false, comment: "期(カレンダー)"
    t.datetime "created_at", precision: nil, null: false
    t.string "line_id", limit: 50, default: "", null: false
    t.string "login_name", limit: 12, null: false, comment: "ログイン名"
    t.string "mail", limit: 255, default: "", null: false, comment: "メールアドレス"
    t.datetime "mail_confirmation_expired_at", comment: "メールアドレス確認有効期限"
    t.string "mail_confirmation_token", limit: 64, comment: "メールアドレス確認トークン"
    t.datetime "mail_confirmed_at", comment: "メールアドレス確認日時"
    t.integer "organization_id", default: 0, null: false, comment: "組織"
    t.boolean "otp_enabled", default: false, null: false, comment: "2段階認証フラグ"
    t.datetime "otp_last_used_at", comment: "2段階認証 最終使用日時"
    t.json "otp_secret", comment: "2段階認証 秘密鍵"
    t.string "password_digest", limit: 128, null: false, comment: "パスワード"
    t.integer "permission_id", default: 0, null: false, comment: "権限"
    t.date "target_from", default: "2010-01-01", null: false, comment: "開始年月"
    t.date "target_to", default: "2010-12-31", null: false, comment: "終了年月"
    t.integer "term", default: 0, null: false, comment: "期"
    t.integer "theme", default: 0, null: false, comment: "画面テーマ"
    t.string "token", limit: 36, default: "", null: false, comment: "アクセストークン"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "view_month", default: [1, 4, 8], null: false, comment: "表示切替月", array: true
    t.integer "worker_id", comment: "作業者"
    t.index ["login_name"], name: "index_users_on_login_name", unique: true
    t.index ["mail"], name: "ix_users_on_mail", unique: true, where: "((mail)::text <> ''::text)"
    t.index ["mail_confirmation_token"], name: "ix_users_on_mail_confirmation_token", unique: true, where: "(mail_confirmation_token IS NOT NULL)"
    t.index ["token"], name: "ix_users_token", unique: true
    t.index ["worker_id"], name: "index_users_on_worker_id", unique: true
  end

  create_table "whole_crop_lands", comment: "WCS土地", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "display_order", default: 0, null: false, comment: "番号"
    t.decimal "rolls", precision: 3, default: "0", null: false, comment: "ロール数"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "work_land_id", default: 0, null: false, comment: "作業地"
    t.integer "work_whole_crop_id", default: 0, null: false, comment: "WCS作業"
    t.index ["work_whole_crop_id", "work_land_id"], name: "index_whole_crop_lands_on_work_whole_crop_id_and_work_land_id", unique: true
  end

  create_table "whole_crop_rolls", comment: "WCSロール", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "display_order", default: 0, null: false, comment: "番号"
    t.datetime "updated_at", precision: nil, null: false
    t.decimal "weight", precision: 4, scale: 1, default: "0.0", null: false, comment: "重量"
    t.integer "whole_crop_land_id", default: 0, null: false, comment: "WCS土地"
  end

  create_table "work_broccolis", id: { type: :serial, comment: "ブロッコリー作業" }, comment: "ブロッコリー作業", force: :cascade do |t|
    t.integer "broccoli_box_id", comment: "箱"
    t.decimal "cost", precision: 6, comment: "販売経費"
    t.datetime "created_at", precision: nil, null: false
    t.decimal "rest", precision: 3, default: "0", null: false, comment: "残数"
    t.decimal "sale", precision: 6, comment: "販売金額"
    t.date "shipped_on", null: false, comment: "出荷日"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "work_id", null: false, comment: "作業"
    t.index ["work_id"], name: "index_work_broccolis_on_work_id", unique: true
  end

  create_table "work_categories", comment: "作業カテゴリ", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "discarded_at", comment: "論理削除日時"
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.string "name", limit: 10, default: "", null: false, comment: "名称"
    t.datetime "updated_at", null: false
  end

  create_table "work_chemicals", id: { type: :serial, comment: "薬剤使用データ" }, comment: "薬剤使用データ", force: :cascade do |t|
    t.boolean "area_flag", default: false, null: false, comment: "10a当たり入力"
    t.integer "chemical_group_no", default: 1, null: false, comment: "薬剤グループ番号"
    t.integer "chemical_id", null: false, comment: "薬剤"
    t.datetime "created_at", precision: nil
    t.integer "dilution_id", default: 0, null: false, comment: "希釈"
    t.decimal "magnification", precision: 5, scale: 1, comment: "水溶液(リットル)"
    t.decimal "quantity", precision: 5, scale: 1, default: "0.0", null: false, comment: "使用量"
    t.text "remarks", default: "", null: false, comment: "備考"
    t.datetime "updated_at", precision: nil
    t.integer "work_id", null: false, comment: "作業"
    t.index ["work_id", "chemical_id", "chemical_group_no"], name: "work_chemicals_2nd_key", unique: true
  end

  create_table "work_genres", comment: "作業ジャンル", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "discarded_at", comment: "論理削除日時"
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.string "graph_color", limit: 8, default: "#ffffff", null: false, comment: "グラフ色"
    t.string "name", limit: 10, default: "", null: false, comment: "名称"
    t.datetime "updated_at", null: false
    t.bigint "work_category_id", null: false, comment: "作業カテゴリ"
    t.index ["work_category_id"], name: "index_work_genres_on_work_category_id"
  end

  create_table "work_kind_prices", id: { type: :serial, comment: "作業単価マスタ" }, comment: "作業単価マスタ", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.decimal "price", precision: 5, default: "1000", null: false, comment: "単価"
    t.integer "term", null: false, comment: "年度(期)"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "work_kind_id", null: false, comment: "作業種別"
    t.index ["term", "work_kind_id"], name: "index_work_kind_prices_on_term_and_work_kind_id", unique: true
  end

  create_table "work_kind_types", id: { type: :serial, comment: "作業種別分類対応マスタ" }, comment: "作業種別分類対応マスタ", force: :cascade do |t|
    t.bigint "work_category_id", null: false, comment: "作業カテゴリ"
    t.integer "work_kind_id", comment: "作業種別"
    t.index ["work_category_id"], name: "index_work_kind_types_on_work_category_id"
  end

  create_table "work_kinds", id: { type: :serial, comment: "作業種別マスタ" }, comment: "作業種別マスタ", force: :cascade do |t|
    t.string "broccoli_mark", limit: 1, comment: "ブロッコリ記号"
    t.integer "cost_type_id", comment: "原価種別"
    t.datetime "created_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.integer "display_order", null: false, comment: "表示順"
    t.boolean "land_flag", default: true, null: false, comment: "土地利用フラグ"
    t.string "name", limit: 20, null: false, comment: "作業種別名称"
    t.boolean "other_flag", default: false, null: false, comment: "その他フラグ"
    t.string "phonetic", limit: 40, default: "", null: false, comment: "作業種別ふりがな"
    t.datetime "updated_at", precision: nil
    t.index ["deleted_at"], name: "index_work_kinds_on_deleted_at"
  end

  create_table "work_lands", id: { type: :serial, comment: "作業地データ" }, comment: "作業地データ", force: :cascade do |t|
    t.integer "chemical_group_no", default: 0, null: false, comment: "薬剤グループ番号"
    t.datetime "created_at", precision: nil
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.decimal "fixed_cost", precision: 6, comment: "確定作業原価"
    t.integer "land_id", comment: "土地"
    t.datetime "updated_at", precision: nil
    t.integer "work_id", comment: "作業"
    t.integer "work_type_id", comment: "作業分類"
    t.index ["work_id", "land_id"], name: "index_work_lands_on_work_id_and_land_id", unique: true
  end

  create_table "work_results", id: { type: :serial, comment: "作業結果データ" }, comment: "作業結果データ", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.decimal "fixed_amount", precision: 7, comment: "確定作業日当"
    t.decimal "fixed_hours", precision: 5, scale: 1, comment: "確定作業時間"
    t.decimal "fixed_price", precision: 5, comment: "確定作業単価"
    t.integer "health_id", default: 0, null: false, comment: "健康"
    t.decimal "hours", precision: 5, scale: 1, default: "0.0", null: false, comment: "作業時間"
    t.string "remarks", limit: 20, default: "", null: false, comment: "備考"
    t.datetime "updated_at", precision: nil
    t.string "uuid", limit: 36, comment: "UUID(カレンダー用)"
    t.integer "work_id", comment: "作業"
    t.integer "worker_id", comment: "作業者"
    t.index ["work_id", "worker_id"], name: "index_work_results_on_work_id_and_worker_id", unique: true
  end

  create_table "work_type_terms", comment: "作業分類年度別マスタ", force: :cascade do |t|
    t.string "bg_color", limit: 8, comment: "背景色"
    t.datetime "created_at", null: false
    t.integer "term", null: false, comment: "年度(期)"
    t.datetime "updated_at", null: false
    t.integer "work_type_id", null: false, comment: "作業分類"
    t.index ["term", "work_type_id"], name: "work_type_terms_2nd", unique: true
  end

  create_table "work_types", id: { type: :serial, comment: "作業分類マスタ" }, comment: "作業分類マスタ", force: :cascade do |t|
    t.string "bg_color", limit: 8, comment: "背景色"
    t.boolean "cost_flag", default: false, null: false, comment: "原価フラグ"
    t.datetime "deleted_at", precision: nil
    t.integer "display_order", default: 0, null: false, comment: "表示順"
    t.binary "icon", comment: "アイコン"
    t.string "icon_name", limit: 40, comment: "アイコン名"
    t.datetime "icon_updated_at"
    t.boolean "land_flag", default: true, null: false, comment: "土地利用"
    t.string "name", limit: 10, null: false, comment: "作業分類名称"
    t.integer "office_role", default: 0, null: false, comment: "事務の役割"
    t.boolean "other_flag", default: false, null: false, comment: "その他フラグ"
    t.boolean "work_flag", default: true, null: false, comment: "日報フラグ"
    t.bigint "work_genre_id", null: false, comment: "作業ジャンル"
    t.index ["deleted_at"], name: "index_work_types_on_deleted_at"
    t.index ["work_genre_id"], name: "index_work_types_on_work_genre_id"
  end

  create_table "work_verifications", id: { type: :serial, comment: "日報検証" }, comment: "日報検証", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "work_id", comment: "作業"
    t.integer "worker_id", comment: "作業者"
    t.index ["work_id", "worker_id"], name: "index_work_verifications_on_work_id_and_worker_id", unique: true
  end

  create_table "work_whole_crops", comment: "WCS作業", force: :cascade do |t|
    t.string "article_name", limit: 15, default: "", null: false, comment: "品名"
    t.datetime "created_at", precision: nil, null: false
    t.decimal "tax_rate", precision: 3, scale: 1, default: "0.0", null: false, comment: "消費税率"
    t.decimal "unit_price", precision: 5, scale: 2, default: "0.0", null: false, comment: "標準単価"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "work_id", null: false, comment: "作業"
    t.index ["work_id"], name: "index_work_whole_crops_on_work_id", unique: true
  end

  create_table "work_work_types", id: false, comment: "作業分類キャッシュ", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "work_id", null: false, comment: "作業"
    t.integer "work_type_id", null: false, comment: "作業分類"
    t.index ["work_id", "work_type_id"], name: "work_work_types_2nd", unique: true
  end

  create_table "workers", id: { type: :serial, comment: "作業者マスタ" }, comment: "作業者マスタ", force: :cascade do |t|
    t.date "birthday", comment: "誕生日"
    t.string "broccoli_mark", limit: 1, comment: "ブロッコリ記号"
    t.datetime "created_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.integer "display_order", comment: "表示順"
    t.string "family_name", limit: 10, null: false, comment: "姓"
    t.string "family_phonetic", limit: 15, null: false, comment: "姓(ﾌﾘｶﾞﾅ)"
    t.string "first_name", limit: 10, null: false, comment: "名"
    t.string "first_phonetic", limit: 15, null: false, comment: "名(ﾌﾘｶﾞﾅ)"
    t.integer "gender_id", default: 0, null: false, comment: "性別"
    t.integer "home_id", comment: "世帯"
    t.string "mobile", limit: 15, comment: "携帯番号"
    t.string "mobile_mail", limit: 50, comment: "メールアドレス(携帯)"
    t.integer "office_role", default: 0, null: false, comment: "事務の役割"
    t.string "pc_mail", limit: 50, comment: "メールアドレス(PC)"
    t.integer "position_id", default: 0, null: false, comment: "役職"
    t.datetime "updated_at", precision: nil
    t.boolean "work_flag", default: true, null: false, comment: "作業フラグ"
    t.index ["deleted_at"], name: "index_workers_on_deleted_at"
  end

  create_table "works", id: { type: :serial, comment: "作業データ" }, comment: "作業データ", force: :cascade do |t|
    t.boolean "chemical_group_flag", default: false, null: false, comment: "薬剤グループフラグ"
    t.datetime "created_at", precision: nil
    t.integer "created_by", comment: "作成者"
    t.time "end_at", null: false, comment: "終了時刻"
    t.date "fixed_at", comment: "確定日"
    t.string "name", limit: 40, null: false, comment: "作業名称"
    t.datetime "printed_at", precision: nil, comment: "印刷日時"
    t.integer "printed_by", comment: "印刷者"
    t.text "remarks", comment: "備考"
    t.time "start_at", null: false, comment: "開始時刻"
    t.integer "term", null: false, comment: "年度(期)"
    t.datetime "updated_at", precision: nil
    t.integer "weather_id", comment: "天気"
    t.integer "work_kind_id", default: 0, null: false, comment: "作業種別"
    t.integer "work_type_id", comment: "作業分類"
    t.date "worked_at", null: false, comment: "作業日"
  end

  add_foreign_key "task_comments", "tasks"
  add_foreign_key "task_comments", "workers", column: "poster_id"
  add_foreign_key "task_events", "task_comments"
  add_foreign_key "task_events", "tasks"
  add_foreign_key "task_events", "workers", column: "actor_id"
  add_foreign_key "task_events", "workers", column: "assignee_from_id"
  add_foreign_key "task_events", "workers", column: "assignee_to_id"
  add_foreign_key "task_events", "works"
  add_foreign_key "task_reads", "tasks"
  add_foreign_key "task_reads", "workers"
  add_foreign_key "task_templates", "organizations"
  add_foreign_key "task_watchers", "tasks"
  add_foreign_key "task_watchers", "workers"
  add_foreign_key "tasks", "task_templates"
  add_foreign_key "tasks", "workers", column: "assignee_id"
  add_foreign_key "tasks", "workers", column: "creator_id"
  add_foreign_key "work_genres", "work_categories"
  add_foreign_key "work_kind_types", "work_categories"
  add_foreign_key "work_types", "work_genres"
end
