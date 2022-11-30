class CreateTrainingTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :training_types, comment: "訓練種別" do |t|
      t.string  :name, limit: 10, null: false, comment: "名称"
      t.integer :display_order, null: false, comment: "表示順"
      t.boolean :other_flag, null: false, default: false, comment: "その他フラグ"

      t.timestamps
    end
    TrainingType.create(name: "美味しまね制度", display_order: 1)
    TrainingType.create(name: "農業", display_order: 2)
    TrainingType.create(name: "肥料", display_order: 3)
    TrainingType.create(name: "労働安全", display_order: 4)
    TrainingType.create(name: "労務管理", display_order: 5)

    TrainingType.create(name: "その他", display_order: 99, other_flag: true)
  end
end
