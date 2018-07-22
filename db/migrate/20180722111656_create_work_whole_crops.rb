class CreateWorkWholeCrops < ActiveRecord::Migration[5.2]
  def change
    create_table :work_whole_crops, comment: "WCS作業" do |t|
      t.integer :work_id, {null: false, comment: "作業"}
      t.decimal :rolls, {scale: 0, precision: 4, null: false, default: 0, comment: "ロール数"}

      t.timestamps
    end
    add_index :work_whole_crops, [:work_id], {unique: true}
    add_column :organizations, :whole_crop_work_kind_id, :integer, {null: true, comment: "WCS収穫分類"}
  end
end
