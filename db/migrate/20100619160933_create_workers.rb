class CreateWorkers < ActiveRecord::Migration[4.2]
  def change
    create_table :workers, {comment: "作業者マスタ"} do |t|
      t.string   :family_phonetic, {limit: 15, null: false, comment: "姓(ﾌﾘｶﾞﾅ)"}
      t.string   :family_name,     {limit: 10, null: false, comment: "姓"}
      t.string   :first_phonetic,  {limit: 15, null: false, comment: "名(ﾌﾘｶﾞﾅ)"}
      t.string   :first_name,      {limit: 10, null: false, comment: "名"}
      t.date     :birthday,        {comment: "誕生日"}
      t.integer  :home_id,         {comment: "世帯"}
      t.string   :mobile,          {limit: 15, comment: "携帯番号"}
      t.string   :mobile_mail,     {limit: 50, comment: "メールアドレス(携帯)"}
      t.string   :pc_mail,         {limit: 50, comment: "メールアドレス(PC)"}
      t.integer  :display_order,   {comment: "表示順"}
      t.boolean  :work_flag,       {default: true, null: false, comment: "作業フラグ"}
      t.integer  :gender_id,       {default: 0, null: false, comment: "性別"}

      t.string  :bank_code,       {null: false, limit: 4, default: "0000", comment: "口座(金融機関)"}
      t.string  :branch_code,     {null: false, limit: 3, default: "000", comment: "口座(支店)"}
      t.integer :account_type_id, {null: false, limit: 1, default: 0, comment: "口座種別"}
      t.string :account_number,   {null: false, limit: 7, default: "0000000", comment: "口座番号"}

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :workers, :deleted_at
  end
end
