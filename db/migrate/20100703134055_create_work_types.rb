class CreateWorkTypes < ActiveRecord::Migration
  def change
    create_table :work_types do |t|
      t.integer   :genre,         {null: false}
      t.string    :name,          {null: false, limit: 10}
      t.boolean   :category_flag, {default: false}
      t.integer   :display_order, {null: false, default: 0}

      t.datetime  :deleted_at,    {null: true}
    end
    add_index :work_types, :deleted_at
  end
end
