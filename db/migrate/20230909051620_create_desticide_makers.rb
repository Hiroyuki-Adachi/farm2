class CreateDesticideMakers < ActiveRecord::Migration[7.0]
  def change
    create_table :desticide_makers, comment: "農薬製造販売元" do |t|
      t.string :name, limit: 50, null: false, comment: "名称"
      t.timestamps
    end
  end
end
