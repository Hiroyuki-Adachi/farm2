class CreateDesticideDetailTotalUses < ActiveRecord::Migration[7.0]
  def change
    create_table :desticide_detail_total_uses, comment: "農薬明細使用回数" do |t|
      t.integer :desticide_id, null: false, comment: "登録番号"
      t.integer :no, null: false, comment: "有効成分番号"
      t.string  :total_uses, limit: 50, null: false, comment: "総使用回数"
      t.timestamps
    end
  end
end
