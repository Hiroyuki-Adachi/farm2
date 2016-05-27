class CreateChemicalTerms < ActiveRecord::Migration
  def change
    create_table :chemical_terms do |t|
      t.integer :chemical_id, {null: false}
      t.integer :term,        {limit: 4, null: false}
    end
    add_index :chemical_terms, [:chemical_id, :term], {unique: true, name: :chemical_terms_sub}
  end
end
