class CreateCalendarWorkKinds < ActiveRecord::Migration[5.2]
  def change
    create_table :calendar_work_kinds, comment: "カレンダー作業種別" do |t|
      t.integer :user_id, {null: false, comment: "利用者"}
      t.integer :work_kind_id, {null: false, comment: "作業種別"}
      t.string :text_color, {limit: 8, null: false, default: "#000000", comment: "文字色"}
      t.timestamps
    end
    add_index :calendar_work_kinds, [:user_id, :work_kind_id], {unique: true, name: "calendar_work_kind_index"}
    add_column :users, :calendar_term, :integer, {null: false, limit: 4, default: 2018, comment: "期(カレンダー)"}
  end
end
