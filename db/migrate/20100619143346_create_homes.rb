class CreateHomes < ActiveRecord::Migration
  def self.up
    create_table :homes do |t|
      t.string   :phonetic,     {limit: 15}
      t.string   :name,         {limit: 10}
      t.integer  :worker_id
      t.string   :zip_code,     {limit: 7}
      t.string   :address1,     {limit: 50}
      t.string   :address2,     {limit: 50}
      t.string   :telephone,    {limit: 15}
      t.string   :fax,          {limit: 15}
      t.integer  :group_number, {limit: 2}
      t.integer  :display_order
      t.integer  :member_flag,  {limit: 1, null: false, default: 1}

      t.timestamps
      t.datetime :deleted_at
    end
  end

  def self.down
    drop_table :homes
  end
end
