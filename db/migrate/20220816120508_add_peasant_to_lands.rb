class AddPeasantToLands < ActiveRecord::Migration[7.0]
  def change
    add_column :lands, :peasant_start_on, :date, null: false, default: "1900-01-01", comment: "小作料期間(自)"
    add_column :lands, :peasant_end_on,   :date, null: false, default: "2999-12-31", comment: "小作料期間(至)"
  end
end
