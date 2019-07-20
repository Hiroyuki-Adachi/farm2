class CreateAdjustments < ActiveRecord::Migration[5.2]
  def change
    create_table :adjustments, comment: "調整" do |t|
      t.integer :drying_id,    {null: false, default: 0, comment: "乾燥"}
      t.integer :home_id,      {null: true, comment: "担当世帯"}
      t.date    :carried_on,   {null: true, comment: "搬入日"}
      t.date    :shipped_on,   {null: true, comment: "出荷日"}
      t.decimal :rice_weight,  {null: true, scale: 1, precision: 5, comment: "調整米(kg)"}
      t.decimal :waste_weight, {null: true, scale: 1, precision: 5, comment: "くず米(kg)"}
      t.decimal :fixed_amount, {null: true, scale: 0, precision: 7, comment: "確定額"}

      t.timestamps
    end
    add_index :adjustments, [:drying_id], {unique: true, name: "adjustments_secondary"}
  end
end
