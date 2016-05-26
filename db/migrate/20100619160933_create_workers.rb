class CreateWorkers < ActiveRecord::Migration
  def change
    create_table :workers do |t|
      t.string   :family_phonetic, {limit: 15, null: false}
      t.string   :family_name,     {limit: 10, null: false}
      t.string   :first_phonetic,  {limit: 15, null: false}
      t.string   :first_name,      {limit: 10, null: false}
      t.date     :birthday
      t.integer  :home_id
      t.string   :mobile,          {limit: 15}
      t.string   :mobile_mail,     {limit: 50}
      t.string   :pc_mail,         {limit: 50}
      t.integer  :display_order
      t.boolean  :work_flag,       {default: true, null: false}
      t.integer  :gender_id,       {default: 0, null: false}

      t.string  :bank_code,       {null: false, limit: 4, default: "0000"}
      t.string  :branch_code,     {null: false, limit: 3, default: "000"}
      t.integer :account_type_id, {null: false, limit: 1, default: 0}
      t.string :account_number,   {null: false, limit: 7, default: "0000000"}

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :workers, :deleted_at
  end
end
