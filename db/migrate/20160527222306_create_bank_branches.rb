class CreateBankBranches < ActiveRecord::Migration[4.2]
  def change
    create_table :bank_branches, {id: false, comment: "支店マスタ"} do |t|
      t.string :bank_code, {null: false, limit: 4, comment: "金融機関コード"}
      t.string :code, {null: false, limit: 3, comment: "支店コード"}
      t.string :name, {null: false, limit: 40, comment: "支店名称"}
      t.string :phonetic, {null: false, limit: 40, comment: "支店名称(ﾌﾘｶﾞﾅ)"}
      t.string :zip_code,     {limit: 7, comment: "郵便番号"}
      t.string :address1,     {limit: 50, comment: "住所1"}
      t.string :address2,     {limit: 50, comment: "住所2"}
      t.string :telephone,    {limit: 15, comment: "電話番号"}
      t.string :fax,          {limit: 15, comment: "FAX番号"}

      t.timestamps null: false
    end
    execute "ALTER TABLE bank_branches ADD PRIMARY KEY (bank_code, code);"
  end
end
