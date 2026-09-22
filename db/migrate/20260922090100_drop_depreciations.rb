class DropDepreciations < ActiveRecord::Migration[8.1]
  # #1255: 会計上の減価償却の手動入力画面(未使用)を、基盤強化準備金原価(machine_reserve_funds系)に置き換える。
  # メニュー未導線でTotalCostにも未配線のため実データは無いと想定しているが、
  # 本番適用前に depreciations の件数が0件であることを別途確認すること。
  def up
    depreciations_count = select_value("SELECT count(*) FROM depreciations").to_i
    if depreciations_count.positive?
      raise ActiveRecord::MigrationError,
            "depreciations has #{depreciations_count} row(s). Investigate before dropping " \
            "(see docs/issue-1228-machine-depreciation-cost.md)."
    end

    drop_table :depreciation_types
    drop_table :depreciations
    remove_column :total_costs, :depreciation_id, :integer, comment: "減価償却"
  end

  def down
    create_table :depreciations, comment: "減価償却" do |t|
      t.integer :term, limit: 4, null: false, comment: "年度(期)"
      t.integer :machine_id, comment: "機械"
      t.decimal :cost, precision: 9, default: 0, null: false, comment: "減価償却費"

      t.timestamps null: false
    end
    add_index :depreciations, [:term, :machine_id], unique: true

    create_table :depreciation_types, comment: "減価償却分類" do |t|
      t.integer :depreciation_id, comment: "減価償却"
      t.integer :work_type_id, null: false, comment: "作業分類"

      t.timestamps null: false
    end
    add_index :depreciation_types, [:depreciation_id, :work_type_id], unique: true

    add_column :total_costs, :depreciation_id, :integer, comment: "減価償却"
  end
end
