class CreateCleaningTargets < ActiveRecord::Migration[7.0]
  def change
    create_table :cleaning_targets, comment: "清掃種別マスタ" do |t|
      t.string :name, limit: 10, null: false, default: "", comment: "名称"
      t.integer :display_order, null: false, default: 0, comment: "表示順"
      t.timestamps
    end
    CleaningTarget.create(name: "清掃", display_order: 1)
    CleaningTarget.create(name: "動物駆除", display_order: 2)
    CleaningTarget.create(name: "害虫駆除", display_order: 3)
  end
end
