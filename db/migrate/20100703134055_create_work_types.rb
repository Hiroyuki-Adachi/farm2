class CreateWorkTypes < ActiveRecord::Migration
  def self.up
    create_table :work_types do |t|
      t.integer   :genre,         {null: false}
      t.string    :name,          {null: false, limit: 10}
      t.boolean   :category_flag, {default: false}
      t.integer   :display_order, {null: false, default: 0}

      t.timestamps
      t.datetime  :deleted_at,    {null: true}
    end
  end

  def self.down
    drop_table :work_types
  end
end
