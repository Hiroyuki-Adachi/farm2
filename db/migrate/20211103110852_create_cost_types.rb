class CreateCostTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :cost_types, {comment: "原価種別"} do |t|
      t.string  :name,          {limit: 10, null: false, comment: "原価種別名称"}
      t.string  :phonetic,      {limit: 20, null: false, comment: "原価種別名称(ふりがな)"}
      t.integer :display_order, {limit: 4, null: false, default: 0, comment: "表示順"}
      t.timestamps
    end
    add_column :work_kinds, :cost_type_id, :integer, {null: true, comment: "原価種別"}
  end
end
