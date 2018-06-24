class AddPriceToSystem < ActiveRecord::Migration
  def change
    add_column :systems, :default_price, :decimal, {scale: 0, precision: 5, null: false, default: 1000, comment: "初期値(工賃)"}
    add_column :systems, :default_fee,   :decimal, {scale: 0, precision: 6, null: false, default: 15000, comment: "初期値(管理料)"}
  end
end
