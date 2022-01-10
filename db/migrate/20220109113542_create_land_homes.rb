class CreateLandHomes < ActiveRecord::Migration[6.1]
  def change
    create_table :land_homes, comment: "土地管理" do |t|
      t.integer :land_id,     null: false, comment: "土地"
      t.integer :home_id,     null: true, comment: "世帯"
      t.boolean :manager_flag,  null: true, comment: "管理者フラグ"
      t.boolean :owner_flag,  null: true, comment: "所有者フラグ"
      t.decimal :area,        null: false, scale: 2, precision: 5, comment: "面積"
      t.string  :place,       null: false, limit: 15, comment: "番地"

      t.timestamps
    end
  end
end
