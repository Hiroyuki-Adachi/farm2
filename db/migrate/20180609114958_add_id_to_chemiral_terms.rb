class AddIdToChemiralTerms < ActiveRecord::Migration[4.2]
  def up
    execute "ALTER TABLE chemical_terms DROP CONSTRAINT chemical_terms_pkey;"
    add_column :chemical_terms, :id, :serial, {null: false}
    add_column :chemical_terms, :price, :decimal, {scale: 0, precision: 6, null: false, default: 0, comment: "価格"}
    execute "ALTER TABLE chemical_terms ADD PRIMARY KEY (id);"
    add_index :chemical_terms, [:chemical_id, :term], {unique: true}
  end

  def down
    remove_index :chemical_terms, [:chemical_id, :term]
    execute "ALTER TABLE chemical_terms DROP CONSTRAINT chemical_terms_pkey;"
    remove_column :chemical_terms, :id
    remove_column :chemical_terms, :price
    execute "ALTER TABLE chemical_terms ADD PRIMARY KEY (chemical_id, term);"
  end
end
