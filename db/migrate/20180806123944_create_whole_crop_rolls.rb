class CreateWholeCropRolls < ActiveRecord::Migration[5.2]
  def change
    create_table :whole_crop_rolls, comment: "WCSロール" do |t|
      t.integer :whole_crop_land_id, {null: false, default: 0, comment: "WCS土地"}
      t.integer :display_order, {null: false, default: 0, comment: "番号"}
      t.decimal :weight, {scale: 1, precision: 4, null: false, default: 0, comment: "重量"}

      t.timestamps
    end
  end
end
