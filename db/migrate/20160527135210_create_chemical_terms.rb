class CreateChemicalTerms < ActiveRecord::Migration
  def change
    create_table :chemical_terms, {id: false} do |t|
      t.integer :chemical_id, {null: false}
      t.integer :term,        {limit: 4, null: false}
    end
    execute "ALTER TABLE chemical_terms ADD PRIMARY KEY (chemical_id, term);"
  end
end
