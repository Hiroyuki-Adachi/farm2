class CreateDesticideUses < ActiveRecord::Migration[7.0]
  def change
    create_table :desticide_uses, comment: "使用方法" do |t|
      t.string :name, limit: 50, null: false, comment: "使用方法"
      t.timestamps
    end
  end
end
