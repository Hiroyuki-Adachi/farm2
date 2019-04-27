class AddGroupNoToWorkChemicals < ActiveRecord::Migration[4.2]
  def up
    remove_index :work_chemicals, [:work_id, :chemical_id]
    add_column :work_chemicals, :chemical_group_no, :integer, {null: false, default: 1, comment: "薬剤グループ番号"}
    add_column :organizations, :chemical_group_count, :integer, {null: true, default: 1, comment: "薬剤グループ数"}
    add_index :work_chemicals, [:work_id, :chemical_id, :chemical_group_no], {unique: true, name: :work_chemicals_2nd_key}
  end

  def down
    remove_index :work_chemicals, name: :work_chemicals_2nd_key
    remove_column :work_chemicals, :chemical_group_no
    remove_column :organizations, :chemical_group_count
    add_index :work_chemicals, [:work_id, :chemical_id], {unique: true}
  end
end
