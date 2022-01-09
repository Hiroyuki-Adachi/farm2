class CreateLandHomes < ActiveRecord::Migration[6.1]
  def change
    create_table :land_homes, comment: "土地管理" do |t|
      t.integer :land_id,     null: false, comment: "土地"
      t.integer :owner_id,    null: true, comment: "所有世帯"
      t.integer :manager_id,  null: true, comment: "管理世帯"
      t.decimal :reg_area,    null: false, scale: 2, precision: 5, comment: "登記面積"
      t.decimal :area,        null: false, scale: 2, precision: 5, comment: "耕作面積"
      t.string  :place,       null: false, limit: 15, comment: "番地"

      t.timestamps
    end
  end
end
