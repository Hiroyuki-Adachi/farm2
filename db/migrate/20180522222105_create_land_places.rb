class CreateLandPlaces < ActiveRecord::Migration[4.2]
  def change
    create_table :land_places, {comment: "場所マスタ"} do |t|
      t.string  :name, {limit: 40, null: false, comment: "場所名称"}
      t.text    :remarks, {null: true, comment: "備考"}
      t.integer :display_order, {comment: "表示順"}

      t.timestamps null: false
      t.datetime :deleted_at
    end
    add_column :lands, :land_place_id, :integer, {null: true, comment: "土地"}
  end
end
