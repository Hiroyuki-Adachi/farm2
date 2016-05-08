class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string  :show_work1,    {null: false, limit: 10}
      t.string  :show_work2,    {null: false, limit: 10}
      t.integer :workers_count, {null: false, limit: 2, default: 12}
      t.integer :lands_count,   {null: false, limit: 2, default: 12}

      t.timestamps
    end
  end
end
