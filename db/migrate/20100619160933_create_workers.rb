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
      t.integer  :gender_type,     {limit: 1, default: 0, null: false}  #0:no set

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :workers, :deleted_at
  end
end
