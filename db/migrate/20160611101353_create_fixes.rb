class CreateFixes < ActiveRecord::Migration
  def change
    create_table :fixes, id: false do |t|
      t.date :fixed_at, {null: false}
      t.integer :works_count, {null: false}
      t.integer :hours, {null: false}
      t.decimal :works_amount,    {scale: 0, precision: 8, null: false}
      t.decimal :machines_count,  {scale: 0, precision: 8, null: false}

      t.timestamps null: false
    end
    execute "ALTER TABLE fixes ADD PRIMARY KEY (fixed_at);"
  end
end
