class CreateDryingLands < ActiveRecord::Migration[5.2]
  def change
    create_table :drying_lands, comment: "乾燥調整場所" do |t|
      t.integer :drying_id,  {null: false, default: 0, comment: "乾燥調整"}
      t.integer :land_id,    {null: false, default: 0, comment: "作業地"}
      t.decimal :percentage, {null: false, default: 100, scale: 1, precision: 4, comment: "割合"}

      t.timestamps
    end
    add_index :drying_lands, [:drying_id, :land_id], {unique: true, name: "drying_lands_secondary"}
  end
end
