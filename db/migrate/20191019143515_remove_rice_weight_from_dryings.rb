class RemoveRiceWeightFromDryings < ActiveRecord::Migration[5.2]
  def up
    remove_column :dryings, :rice_weight
  end

  def down
    add_column :dryings, :rice_weight, :decimal, {null: true, scale: 1, precision: 5, comment: "乾燥米(kg)"}
  end
end
