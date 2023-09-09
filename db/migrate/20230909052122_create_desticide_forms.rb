class CreateDesticideForms < ActiveRecord::Migration[7.0]
  def change
    create_table :desticide_forms, comment: "剤型" do |t|
      t.string :name, limit: 20, null: false, comment: "名称"
      t.timestamps
    end
  end
end
