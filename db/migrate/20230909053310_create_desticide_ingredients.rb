class CreateDesticideIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :desticide_ingredients, comment: "農薬有効成分" do |t|
      t.integer :desticide_id, null: false, comment: "登録番号"
      t.integer :no, null: false, comment: "有効成分番号"
      t.string  :ingredient, limit: 100, null: false, comment: "有効成分"
      t.string  :count_ingredient, limit: 100, null: false, comment: "総使用回数における有効成分"
      t.string  :concentration, limit: 50, null: false, comment: "濃度"
      t.float   :concentration_value, null: true, comment: "濃度(%)"

      t.timestamps
    end
  end
end
