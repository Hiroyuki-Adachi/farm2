class ChangeQuantityOfStocks < ActiveRecord::Migration[7.0]
  def change
    change_column :chemical_stocks, :stored,    :decimal, precision: 7, scale: 1, comment: "入庫量"
    change_column :chemical_stocks, :shipping,  :decimal, precision: 7, scale: 1, comment: "出庫量"
    change_column :chemical_stocks, :using,     :decimal, precision: 7, scale: 1, comment: "使用量"
    change_column :chemical_stocks, :inventory, :decimal, precision: 8, scale: 1, comment: "棚卸量"
    change_column :chemical_stocks, :stock,     :decimal, precision: 8, scale: 1, null: false, default: 0, comment: "在庫量"
    change_column :chemical_stocks, :adjust,    :decimal, precision: 7, scale: 1, null: false, default: 0, comment: "調整量"
  end
end
