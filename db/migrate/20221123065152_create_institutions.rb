class CreateInstitutions < ActiveRecord::Migration[7.0]
  def change
    create_table :institutions, comment: "施設マスタ" do |t|
      t.string  :name,        limit: 40,  null: false,  comment: "施設名称"
      t.integer :start_term,  limit: 4,   null: false, default: 0,    comment: "稼動開始年度"
      t.integer :end_term,    limit: 4,   null: false, default: 9999, comment: "稼動終了年度"
      t.integer :display_order,           null: false,  comment: "表示順"
      t.point   :location,    null: true, comment: "位置"

      t.timestamps
    end
  end
end
