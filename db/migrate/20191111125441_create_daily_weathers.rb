class CreateDailyWeathers < ActiveRecord::Migration[5.2]
  def change
    create_table :daily_weathers, {id: false, comment: "気象"} do |t|
      t.date  :target_date, {null: false, comment: "対象日"}
      t.float :height, {null: true, comment: "最高気温"}
      t.float :lowest, {null: true, comment: "最低気温"}
      t.float :humidity, {null: true, comment: "湿度"}
      t.float :sunshine, {null: true, comment: "日照時間"}
      t.float :rain, {null: true, comment: "降水量"}
      t.float :snow, {null: true, comment: "降雪量"}
      t.float :pressure, {null: true, comment: "気圧"}
      t.float :wind_speed, {null: true, comment: "風速"}
      t.string :wind_direction, {limit: 3, null: true, comment: "風向"}
      t.timestamps
    end
    execute "ALTER TABLE daily_weathers ADD PRIMARY KEY (target_date);"
  end
end
