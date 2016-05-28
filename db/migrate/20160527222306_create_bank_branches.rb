class CreateBankBranches < ActiveRecord::Migration
  def change
    create_table :bank_branches, {id: false} do |t|
      t.string :bank_code, {null: false, limit: 4}
      t.string :code, {null: false, limit: 3}
      t.string :name, {null: false, limit: 40}
      t.string :phonetic, {null: false, limit: 40}
      t.string :zip_code,     {limit: 7}
      t.string :address1,     {limit: 50}
      t.string :address2,     {limit: 50}
      t.string :telephone,    {limit: 15}
      t.string :fax,          {limit: 15}

      t.timestamps null: false
    end
    execute "ALTER TABLE bank_branches ADD PRIMARY KEY (bank_code, code);"
  end
end
