class CreateWholeCropLands < ActiveRecord::Migration[5.2]
  def change
    create_table :whole_crop_lands, comment: "WCS土地" do |t|
      t.integer :work_whole_crop_id, {null: false, default: 0, comment: "WCS作業"}
      t.integer :work_land_id, {null: false, default: 0, comment: "作業地"}
      t.integer :display_order, {null: false, default: 0, comment: "番号"}
      t.decimal :rolls, {scale: 0, precision: 3, null: false, default: 0, comment: "ロール数"}

      t.timestamps
    end
    add_index :whole_crop_lands, [:work_whole_crop_id, :work_land_id], {unique: true}
    add_index :whole_crop_lands, [:work_whole_crop_id, :display_order], {unique: true}
  end
end
