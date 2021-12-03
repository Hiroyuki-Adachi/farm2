class AddWastePriceToSystems < ActiveRecord::Migration[6.1]
  def up
    remove_column :systems, :waste_sum_flag
    add_column :systems, :waste_price, :decimal, {null: false, precision: 4, default: 0, comment: "くず米金額"}
  end

  def down
    add_column :systems, :waste_sum_flag, :boolean, {null: false, default: false, comment: "くず米集計フラグ"}
    remove_column :systems, :waste_price
  end
end
