class CreatePesticideMasters < ActiveRecord::Migration[8.0]
  def change
    create_table :pesticide_masters, comment: "統合農薬マスタ" do |t|
      t.integer :registration_number, null: false, comment: "登録番号"
      t.string :name, limit: 255, null: false, default: "", comment: "農薬の名称"
      t.string :pesticide_kind, limit: 255, null: false, default: "", comment: "農薬の種類"
      t.string :registrant_name, limit: 255, null: false, default: "", comment: "登録を有する者の名称"
      t.string :usage, limit: 50, null: false, default: "", comment: "用途"
      t.string :formulation_name, limit: 50, null: false, default: "", comment: "剤型名"
      t.integer :mixture_count, null: false, default: 0, comment: "混合数"
      t.date :registered_on, comment: "登録年月日"

      t.timestamps
    end

    add_index :pesticide_masters, :registration_number, unique: true

    add_reference :chemicals,
                  :pesticide_master,
                  foreign_key: true,
                  index: true,
                  comment: "統合農薬マスタ"
  end
end
