class CreateCleanings < ActiveRecord::Migration[7.0]
  def change
    create_table :cleanings, comment: "清掃" do |t|
      t.integer :work_id,       null: false, default: 0, comment:"作業ID"
      t.string  :target,        limit: 20, null: false, default: "", comment: "駆除対象"
      t.string  :method,        limit: 20, null: false, default: "", comment: "清掃方法"
      t.boolean :cleaning_flag, null: false, default: false, comment:"清掃フラグ"
      t.boolean :animal_flag,   null: false, default: false, comment:"動物駆除フラグ"
      t.boolean :pest_flag,     null: false, default: false, comment:"害虫駆除フラグ"
      t.timestamps
    end
  end
end
