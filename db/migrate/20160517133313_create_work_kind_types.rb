class CreateWorkKindTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :work_kind_types, {comment: "作業種別分類対応マスタ"} do |t|
      t.integer :work_kind_id, {comment: "作業種別"}
      t.integer :work_type_id, {comment: "作業分類"}
    end
    add_index :work_kind_types, [:work_kind_id, :work_type_id], {unique: true}
  end
end
