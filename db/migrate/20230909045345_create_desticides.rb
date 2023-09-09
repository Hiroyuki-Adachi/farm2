class CreateDesticides < ActiveRecord::Migration[7.0]
  def change
    create_table :desticides, id: false, comment: "農薬" do |t|
      t.column  :id, 'INTEGER PRIMARY KEY NOT NULL'
      t.string  :type_name, limit: 100, null: false, comment: "種類"
      t.string  :name, limit: 100, null: false, comment: "名称"
      t.integer :maker_id, null: false, comment: "製造元"
      t.integer :mixed_count, null: false, comment: "混合数"
      t.integer :purpose_id, null: false, comment: "用途"
      t.integer :form_id, null: false, comment: "剤型"

      t.date    :registed_on,  comment: "登録年月日"
      t.timestamps
    end
  end
end
