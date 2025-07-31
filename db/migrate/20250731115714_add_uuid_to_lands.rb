class AddUuidToLands < ActiveRecord::Migration[8.0]
  def change
    add_column :lands, :uuid, :string, limit: 36, null: false, default: "", comment: "UUID"

    Land.all.each do |land|
      land.set_uuid
      land.save!
    end

    add_index :lands, :uuid, unique: true, where: "uuid <> ''", name: "index_lands_on_uuid"
  end
end
