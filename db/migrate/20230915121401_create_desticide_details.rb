class CreateDesticideDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :desticide_details, comment: "農薬明細" do |t|
      t.integer :desticide_id, null: false, comment: "登録番号"
      t.integer :crop_id, null: false, comment: "作物"
      t.text    :place_name, null: false, comment: "適用場所"
      t.integer :pest_id, null: false, comment: "病害虫"
      t.text    :purpose, null: false, comment: "使用目的"
      t.text    :use_amount, null: false, comment: "使用量"
      t.text    :spread_amount, null: false, comment: "散布液料"
      t.text    :usage_period, null: false, comment: "使用時期"
      t.text    :total_uses, null: false, comment: "使用回数"
      t.text    :use, null: false, comment: "使用方法"
      t.text    :fumigation_time, null: false, comment: "くん蒸時間"
      t.text    :fumigation_temp, null: false, comment: "くん蒸温度"
      t.text    :applicable_soil, null: false, comment: "適用土壌"
      t.text    :applicable_zone, null: false, comment: "適用地帯名"
      t.text    :applicable_pest, null: false, comment: "適用農薬名"

      t.timestamps
    end
    add_index :desticide_details, [:desticide_id, :crop_id, :pest_id], unique: true, name: :desticide_details_2nd_key
  end
end
