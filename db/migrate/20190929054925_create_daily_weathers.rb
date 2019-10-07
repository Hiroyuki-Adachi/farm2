class CreateDailyWeathers < ActiveRecord::Migration[5.2]
  def change
    create_table :daily_weathers, {id: false, comment: "気象"} do |t|
      t.date  :target_date, {null: false, comment: "対象日"}
      t.float :height, {null: true, comment: "最高気温"}
      t.float :lowest, {null: true, comment: "最低気温"}
      t.float :sunshine, {null: true, comment: "日照時間"}
      t.float :rain, {null: true, comment: "降水量"}
      t.boolean :force_flag, {null: false, default: true, comment: "強制取得フラグ"}
      t.timestamps
    end
    execute "ALTER TABLE daily_weathers ADD PRIMARY KEY (target_date);"
  end
end
