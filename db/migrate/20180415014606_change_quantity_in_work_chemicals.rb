class ChangeQuantityInWorkChemicals < ActiveRecord::Migration
  def up
    change_column :work_chemicals, :quantity, :decimal, {scale: 1, precision: 5, null: false, default: 0, comment: "使用量"}
  end

  def down
    change_column :work_chemicals, :quantity, :decimal, {scale: 0, precision: 3, null: false, default: 0, comment: "使用量"}
  end
end
