class CreateDesticideDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :desticide_details, comment: "農薬明細" do |t|
      t.integer :crop_id, null: false, comment: "作物"
      t.string  :place_name, limit: 50, null: false, commit: "適用場所"
      t.integer :pest_id, null: false, comment: "病害虫"
      t.string  :purpose, limit: 50, null: false, comment: "使用目的"
      t.string  :use_amount, limit: 50, null: false, comment: "使用量"
      t.string  :spread_amount, limit: 50, null: false, comment: "散布液料"
      t.string  :usage_period, limit: 50, null: false, comment: "使用時期"
      t.string  :total_uses, limit: 50, null: false, comment: "使用回数"
      t.integer :use_id, null: false, comment: "使用方法"
      t.string  :fumigation_time, limit: 50, null: false, comment: "くん蒸時間"
      t.string  :fumigation_temp, limit: 50, null: false, comment: "くん蒸温度"
      t.string  :applicable_soil, limit: 50, null: false, comment: "適用土壌"
      t.string  :applicable_zone, limit: 50, null: false, comment: "適用地帯名"
      t.string  :applicable_pest, limit: 50, null: false, comment: "適用農薬名"

      t.timestamps
    end
  end
end
