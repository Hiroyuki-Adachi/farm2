class AddPeasantToLands < ActiveRecord::Migration[7.0]
  def change
    add_column :lands, :peasant_start_term, :integer, limit: 4, null: false, default: 0,    comment: "小作料期間(自)"
    add_column :lands, :peasant_end_term,   :integer, limit: 4, null: false, default: 9999, comment: "小作料期間(至)"
  end
end
