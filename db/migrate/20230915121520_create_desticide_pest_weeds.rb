class CreateDesticidePestWeeds < ActiveRecord::Migration[7.0]
  def change
    create_table :desticide_pest_weeds, comment: "適用病害虫雑草" do |t|
      t.string :name, limit: 50, null: false, comment: "適用病害虫雑草名"
      t.timestamps
    end
  end
end
