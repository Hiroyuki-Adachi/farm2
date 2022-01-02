class CreateChemicalInventories < ActiveRecord::Migration[6.1]
  def change
    create_table :chemical_inventories, comment: "農薬棚卸" do |t|
      t.date      :checked_on,  null: false, comment: "確認日"
      t.integer   :chemical_adjust_type_id, null: false, default: 0, comment: "在庫調整種別"
      t.string    :name,        limit: 40, null: false, default: "", comment: "棚卸名称"

      t.timestamps
    end
  end
end
