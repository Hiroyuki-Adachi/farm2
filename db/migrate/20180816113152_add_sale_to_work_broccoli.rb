class AddSaleToWorkBroccoli < ActiveRecord::Migration[5.2]
  def up
    add_column :work_broccolis, :sale, :decimal, {scale: 0, precision: 6, null: true, comment: "販売金額"}
    add_column :work_broccolis, :cost, :decimal, {scale: 0, precision: 6, null: true, comment: "販売経費"}
    change_column :work_broccolis, :broccoli_box_id, :integer, {null: true, comment: "箱"}
  end

  def down
    remove_column :work_broccolis, :sale
    remove_column :work_broccolis, :cost
    change_column :work_broccolis, :broccoli_box_id, :integer, {null: false, comment: "箱"}
  end
end
