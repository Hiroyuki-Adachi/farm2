class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works, {comment: "作業データ"} do |t|
      t.integer   :term,          {limit: 4, null: false, comment: "年度(期)"}
      t.date      :worked_at,     {null: false, comment: "作業日"}
      t.integer   :weather_id,    {comment: "天気"}
      t.integer   :work_type_id,  {comment: "作業分類"}
      t.string    :name,          {limit: 40, null: false, comment: "作業名称"}
      t.text      :remarks,       {comment: "備考"}
      t.datetime  :start_at,      {null: false, comment: "開始時刻"}
      t.datetime  :end_at,        {null: false, comment: "終了時刻"}
      t.date      :fixed_at,      {null: true, comment: "確定日"}
      t.integer   :work_kind_id,  {null: false, default: 0, comment: "作業種別"}

      t.timestamps
    end
  end
end
