class AddParcelNumberToLands < ActiveRecord::Migration[8.0]
  def change
    add_column :lands, :parcel_number, :integer, null: true, comment: '耕地番号'
  end
end
