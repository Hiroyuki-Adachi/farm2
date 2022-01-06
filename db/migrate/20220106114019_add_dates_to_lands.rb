class AddDatesToLands < ActiveRecord::Migration[6.1]
  def change
    add_column :lands, :start_on, :date, null: false, default: "1900-01-01", comment: "有効期間(自)"
    add_column :lands, :end_on, :date, null: false, default: "2999-12-31", comment: "有効期間(至)"
  end
end
