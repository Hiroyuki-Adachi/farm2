class CreateLandFees < ActiveRecord::Migration[6.1]
  def change
    create_table :land_fees, {comment: "土地料金"} do |t|
      t.integer :term, {limit: 4, null: false, comment: "年度(期)"}
      t.integer :land_id,      {null: false, comment: "土地"}
      t.decimal :manage_fee, {scale: 1, precision: 7, null: false, default: 0, comment: "管理料"}
      t.decimal :peasant_fee, {scale: 1, precision: 7, null: false, default: 0, comment: "小作料"}

      t.timestamps
    end
  end
end
