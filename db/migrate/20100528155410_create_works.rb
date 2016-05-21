class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.integer   :term,          {limit: 4, null: false}
      t.date      :worked_at,     {null: false}
      t.integer   :weather_id
      t.integer   :work_type_id
      t.string    :name,          {limit: 40, null: false}
      t.text      :remarks
      t.datetime  :start_at,      {null: false}
      t.datetime  :end_at,        {null: false}
      t.date      :payed_at,      {null: true}
      t.integer   :work_kind_id,  {null: false, default: 0}

      t.timestamps
    end
  end
end
