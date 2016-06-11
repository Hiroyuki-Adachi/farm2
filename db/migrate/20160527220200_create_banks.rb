class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks, id: false do |t|
      t.string :code, {null: false, limit: 4}
      t.string :name, {null: false, limit: 40}
      t.string :phonetic, {null: false, limit: 40}

      t.timestamps null: false
    end
    execute "ALTER TABLE banks ADD PRIMARY KEY (code);"
  end
end
