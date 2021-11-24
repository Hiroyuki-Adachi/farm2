class CreateHealths < ActiveRecord::Migration[6.1]
  def change
    create_table :healths, {comment: "健康"} do |t|
      t.string  :name,          {limit: 10, null: false, comment: "原価種別名称"}
      t.string :code,           {limit: 1, null: false, comment: "コード"}
      t.integer :display_order, {limit: 4, null: false, default: 0, comment: "表示順"}
      t.timestamps
      t.datetime :deleted_at
    end
    Health.create(id: 0, name: '良好', code: '1', display_order: 1)
    Health.create(name: '手指等の絆創膏', code: '2', display_order: 2)
    Health.create(name: '発熱', code: '3', display_order: 3)
    Health.create(name: '下痢', code: '4', display_order: 4)
    Health.create(name: 'その他', code: '5', display_order: 5)

    add_column :work_results, :health_id, :integer, {null: false, default: 0, comment: "健康"}
    add_column :work_results, :remarks, :string, {null: false, limit: 20, default: "", comment: "備考"}
    add_column :machine_results, :remarks, :string, {null: false, limit: 20, default: "", comment: "備考"}
  end
end
