class CreateDryingLands < ActiveRecord::Migration[5.2]
  def change
    create_table :drying_lands, comment: "乾燥調整場所" do |t|
      t.integer :drying_id,     {null: false, default: 0, comment: "乾燥調整"}
      t.integer :land_id,       {null: true, comment: "作業地"}
      t.integer :display_order, {null: false, default: 0, comment: "表示順"}
      t.decimal :percentage,    {null: false, default: 100, scale: 1, precision: 4, comment: "割合"}

      t.timestamps
    end
    add_index :drying_lands, [:drying_id, :display_order], {unique: true, name: "drying_lands_3rd"}
  end
end
