class CreateHomes < ActiveRecord::Migration
  def change
    create_table :homes do |t|
      t.string   :phonetic,     {limit: 15}
      t.string   :name,         {limit: 10}
      t.integer  :worker_id
      t.string   :zip_code,     {limit: 7}
      t.string   :address1,     {limit: 50}
      t.string   :address2,     {limit: 50}
      t.string   :telephone,    {limit: 15}
      t.string   :fax,          {limit: 15}
      t.integer  :section_id
      t.integer  :display_order
      t.boolean  :member_flag,  {null: false, default: true}  #組合員か否か
      t.boolean  :worker_payment_flag, {null: false, default: false}  #組合員に支払う(Falseだと世帯に支払う)
      t.boolean  :company_flag, {null: false, default: false}

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :homes, :deleted_at
  end
end
