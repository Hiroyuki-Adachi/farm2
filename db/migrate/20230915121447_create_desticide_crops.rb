class CreateDesticideCrops < ActiveRecord::Migration[7.0]
  def change
    create_table :desticide_crops, comment: "農薬作物" do |t|
      t.string :name, limit: 100, null: false, comment: "作物名"

      t.timestamps
    end
  end
end
