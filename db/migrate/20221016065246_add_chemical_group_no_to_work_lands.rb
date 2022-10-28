class AddChemicalGroupNoToWorkLands < ActiveRecord::Migration[7.0]
  def change
    add_column :work_lands, :chemical_group_no,   :integer, null: false, default: 0, comment: "薬剤グループ番号"
    add_column :works,      :chemical_group_flag, :boolean, null: false, default: false, comment: "薬剤グループフラグ"
  end
end
