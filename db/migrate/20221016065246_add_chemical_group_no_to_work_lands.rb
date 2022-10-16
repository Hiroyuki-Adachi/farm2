class AddChemicalGroupNoToWorkLands < ActiveRecord::Migration[7.0]
  def change
    add_column :work_lands, :chemical_group_no, :integer, null: false, default: 0, comment: "薬剤グループ番号"
  end
end
