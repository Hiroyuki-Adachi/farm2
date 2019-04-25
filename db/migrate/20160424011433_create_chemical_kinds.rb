class CreateChemicalKinds < ActiveRecord::Migration[4.2]
  def change
    create_table :chemical_kinds, {comment: "作業種別薬剤種別利用マスタ"} do |t|
      t.integer :chemical_type_id,  {null: false, comment: "薬剤種別"}
      t.integer :work_kind_id,      {null: false, comment: "作業種別"}
    end
    add_index :chemical_kinds, [:chemical_type_id, :work_kind_id], {unique: true}
  end
end
