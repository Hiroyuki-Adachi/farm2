class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations, {comment: "組織(体系)マスタ"} do |t|
      t.string  :name,          {null: false, limit: 20, comment: "組織名称"}
      
      t.integer :workers_count,   {null: false, limit: 3, default: 12, comment: "作業日報の作業者数"}
      t.integer :lands_count,     {null: false, limit: 3, default: 17, comment: "作業日報の土地数"}
      t.integer :machines_count,  {null: false, limit: 3, default: 8, comment: "作業日報の機械数"}
      t.integer :chemicals_count, {null: false, limit: 3, default: 4, comment: "作業日報の薬剤数"}
      t.integer :daily_worker,    {null: false, limit: 1, default: 0, comment: "作業日報の作業者名付加情報"}

      t.string  :consignor_code,  {null: true, limit: 10, comment: "委託者コード"}
      t.string  :consignor_name,  {null: true, limit: 40, comment: "委託者コード"}
      t.string  :bank_code,       {null: false, limit: 4, default: "0000", comment: "口座の金融機関コード"}
      t.string  :branch_code,     {null: false, limit: 3, default: "000", comment: "口座の支店コード"}
      t.integer :account_type_id, {null: false, limit: 1, default: 0, comment: "口座種別"}
      t.string  :account_number,   {null: false, limit: 7, default: "0000000", comment: "口座番号"}
      t.integer :term,            {null: false, limit: 4, default: 0, comment: "現在の年度(期)"}

      t.timestamps
    end
  end
end
