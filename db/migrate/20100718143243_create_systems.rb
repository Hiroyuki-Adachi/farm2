class CreateSystems < ActiveRecord::Migration
  def change
    create_table :systems, {comment: "システムマスタ"} do |t|
      t.integer  :term,         {limit: 4, null: false, comment: "年度(期)"}
      t.date     :target_from,  {comment: "開始年月"}
      t.date     :target_to,    {comment: "終了年月"}

      t.timestamps
    end
    add_index :systems, [:term], {unique: true}
  end
end
