class AddWasteToSystem < ActiveRecord::Migration[8.0]
  def change
    add_column :systems, :waste_drying_price, :decimal, null: false, precision: 4, default: 0, comment: "くず米金額(乾燥)"
    add_column :systems, :waste_adjust_price, :decimal, null: false, precision: 4, default: 0, comment: "くず米金額(調整)"
  end
end
