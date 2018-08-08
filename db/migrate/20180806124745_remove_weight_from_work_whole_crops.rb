class RemoveWeightFromWorkWholeCrops < ActiveRecord::Migration[5.2]
  def up
    remove_column :work_whole_crops, :rolls
    remove_column :work_whole_crops, :weight
    add_column :work_whole_crops, :unit_price, :decimal, {scale: 2, precision: 5, null: false, default: 0, comment: "標準単価"}
    add_column :work_whole_crops, :tax_rate, :decimal, {scale: 1, precision: 3, null: false, default: 0, comment: "消費税率"}
  end

  def down
    add_column :work_whole_crops, :rolls, :decimal, {scale: 0, precision: 4, null: false, default: 0, comment: "ロール数"}
    add_column :work_whole_crops, :weight, :decimal, {scale: 1, precision: 4, null: false, default: 0, comment: "重量"}
    remove_column :work_whole_crops, :unit_price
    remove_column :work_whole_crops, :tax_rate
  end
end
