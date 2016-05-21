class CreateWorkKindPrices < ActiveRecord::Migration
  def change
    create_table :work_kind_prices do |t|
      t.integer   :term, {null: false}
      t.integer   :work_kind_id, {null: false}
      t.decimal   :price, {scale: 0, precision: 4, null: false, default: 1000}

      t.timestamps null: false
    end
    add_index :work_kind_prices, [:term, :work_kind_id], {unique: true}
  end
end
