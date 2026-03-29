require "nkf"

class AddNormalizedColumnsToPesticideMasters < ActiveRecord::Migration[8.1]
  class MigrationPesticideMaster < ApplicationRecord
    self.table_name = "pesticide_masters"
  end

  def up
    add_column :pesticide_masters, :name_normalized, :string, limit: 255, null: false, default: "", comment: "農薬の名称(正規化)"
    add_column :pesticide_masters, :pesticide_kind_normalized, :string, limit: 255, null: false, default: "", comment: "農薬の種類(正規化)"
    add_column :pesticide_masters, :registrant_name_normalized, :string, limit: 255, null: false, default: "", comment: "登録を有する者の名称(正規化)"

    MigrationPesticideMaster.reset_column_information
    MigrationPesticideMaster.find_each do |record|
      record.update_columns(
        name_normalized: normalize_text(record.name),
        pesticide_kind_normalized: normalize_text(record.pesticide_kind),
        registrant_name_normalized: normalize_text(record.registrant_name)
      )
    end
  end

  def down
    remove_column :pesticide_masters, :registrant_name_normalized
    remove_column :pesticide_masters, :pesticide_kind_normalized
    remove_column :pesticide_masters, :name_normalized
  end

  private

  def normalize_text(text)
    NKF.nkf("-w -W", text.to_s).strip
  end
end
