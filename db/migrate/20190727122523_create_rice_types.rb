class CreateRiceTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :rice_types, comment: "品種(米)" do |t|
      t.string :name, {limit: 10, null: false, default: "", comment: "品種名"}
      t.integer :display_order, {null: false, default: 0, comment: "表示順"}
      t.timestamps
    end
    add_column :work_types, :rice_type_id, :integer, {null: true, comment: "品種(米)"}

    RiceType.create(name: "コシヒカリ", display_order: 10)
    RiceType.create(name: "きぬむすめ", display_order: 20)
    RiceType.create(name: "つや姫", display_order: 30)
    RiceType.create(name: "ミルキー", display_order: 40)
  end
end
