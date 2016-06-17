class CreateHomes < ActiveRecord::Migration
  def change
    create_table :homes, {comment: "世帯マスタ"} do |t|
      t.string   :phonetic,       {limit: 15, comment: "世帯名(よみ)"}
      t.string   :name,           {limit: 10, comment: "世帯名"}
      t.integer  :worker_id,      {comment: "世帯主(代表者)"}
      t.string   :zip_code,       {limit: 7, comment: "郵便番号"}
      t.string   :address1,       {limit: 50, comment: "住所1"}
      t.string   :address2,       {limit: 50, comment: "住所2"}
      t.string   :telephone,      {limit: 15, comment: "電話番号"}
      t.string   :fax,            {limit: 15, comment: "FAX番号"}
      t.integer  :section_id,     {comment: "班／町内"}
      t.integer  :display_order,  {comment: "表示順"}
      t.boolean  :member_flag,    {null: false, default: true, comment: "組合員フラグ"}  #組合員か否か
      t.boolean  :worker_payment_flag, {null: false, default: false, comment: "個人支払フラグ"}  #組合員に支払う(Falseだと世帯に支払う)
      t.boolean  :company_flag,   {null: false, default: false, comment: "営農組合フラグ"}

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :homes, :deleted_at
  end
end
