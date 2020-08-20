class AddFuriganaToMasters < ActiveRecord::Migration[6.0]
  def change
    add_column :chemicals,  :phonetic, :string, {limit: 40, null: false, default: '', comment: "薬剤ふりがな"}
    add_column :work_kinds, :phonetic, :string, {limit: 40, null: false, default: '', comment: "作業種別ふりがな"}
  end
end
