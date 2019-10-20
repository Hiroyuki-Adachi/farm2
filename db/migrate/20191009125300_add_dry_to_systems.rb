class AddDryToSystems < ActiveRecord::Migration[5.2]
  def change
    add_column :systems, :half_sum_flag, :boolean,  {null: false, default: false, comment: "半端米集計フラグ"}
    add_column :systems, :waste_sum_flag, :boolean, {null: false, default: false, comment: "くず米集計フラグ"}
  end
end
