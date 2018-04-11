class AddBroccoliToOrganization < ActiveRecord::Migration
  def up
    add_column :organizations, :broccoli_work_type_id, :integer, {null: true, comment: "ブロッコリ作業分類"}
    add_column :organizations, :broccoli_work_kind_id, :integer, {null: true, comment: "ブロッコリ種別分類"}
  end

  def down
    remove_column :organizations, :broccoli_work_type_id
    remove_column :organizations, :broccoli_work_kind_id
  end
end
