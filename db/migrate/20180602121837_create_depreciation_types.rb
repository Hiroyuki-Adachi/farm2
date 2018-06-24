class CreateDepreciationTypes < ActiveRecord::Migration
  def change
    create_table :depreciation_types, {comment: "減価償却分類"} do |t|
      t.integer :depreciation_id, {comment: "減価償却"}
      t.integer :work_type_id, {null: false, comment: "作業分類"}

      t.timestamps null: false
    end
    add_index :depreciation_types, [:depreciation_id, :work_type_id], {unique: true}
  end
end
