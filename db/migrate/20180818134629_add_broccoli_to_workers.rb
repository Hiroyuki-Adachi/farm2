class AddBroccoliToWorkers < ActiveRecord::Migration[5.2]
  def change
    add_column :workers, :broccoli_mark, :string, {limit: 1, null: true, comment: "ブロッコリ記号"}
    add_column :work_kinds, :broccoli_mark, :string, {limit: 1, null: true, comment: "ブロッコリ記号"}
    add_column :lands, :broccoli_mark, :string, {limit: 1, null: true, comment: "ブロッコリ記号"}
  end
end
