class CreateChemicalInventories < ActiveRecord::Migration[6.1]
  def change
    create_table :chemical_inventories, {comment: "農薬棚卸"} do |t|
      t.date      :checked_on,  {null: false, comment: "確認日"}
      t.string    :name,        {limit: 40, null: false, default: "", comment: "棚卸名称"}

      t.timestamps
    end
  end
end
