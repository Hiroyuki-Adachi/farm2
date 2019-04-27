class CreateChemicalTerms < ActiveRecord::Migration[4.2]
  def change
    create_table :chemical_terms, {id: false, comment: "薬剤年度別利用マスタ"} do |t|
      t.integer :chemical_id, {null: false, comment: "薬剤"}
      t.integer :term,        {limit: 4, null: false, comment: "年度(期)"}
    end
    execute "ALTER TABLE chemical_terms ADD PRIMARY KEY (chemical_id, term);"
  end
end
