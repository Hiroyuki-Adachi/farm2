class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string  :name,          {null: false, limit: 20}
      
      t.integer :workers_count,   {null: false, limit: 3, default: 12}
      t.integer :lands_count,     {null: false, limit: 3, default: 17}
      t.integer :machines_count,  {null: false, limit: 3, default: 8}
      t.integer :chemicals_count, {null: false, limit: 3, default: 4}
      t.integer :daily_worker,    {null: false, limit: 1, default: 0}

      t.string  :consignor_code,  {null: true, limit: 10}
      t.string  :consignor_name,  {null: true, limit: 40}
      t.string  :bank_code,       {null: false, limit: 4, default: "0000"}
      t.string  :branch_code,     {null: false, limit: 3, default: "000"}
      t.integer :account_type_id, {null: false, limit: 1, default: 0}
      t.string  :account_number,   {null: false, limit: 7, default: "0000000"}
      t.integer :term,            {null: false, limit: 4, default: 0}

      t.timestamps
    end
  end
end
