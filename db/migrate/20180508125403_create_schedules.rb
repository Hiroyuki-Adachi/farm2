class CreateSchedules < ActiveRecord::Migration[4.2]
  def change
    create_table :schedules, {comment: "作業予定"} do |t|
      t.integer   :term,          {limit: 4, null: false, comment: "年度(期)"}
      t.date      :worked_at,     {null: false, comment: "作業予定日"}
      t.integer   :work_type_id,  {comment: "作業分類"}
      t.integer   :work_kind_id,  {null: false, default: 0, comment: "作業種別"}
      t.string    :name,          {limit: 40, null: false, comment: "作業名称"}
      t.boolean   :work_flag,     {null: false, default: true, comment: "作業フラグ"}

      t.timestamps null: false
    end
  end
end
