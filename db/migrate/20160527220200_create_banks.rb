class CreateBanks < ActiveRecord::Migration[4.2]
  def change
    create_table :banks, {id: false, comment: "金融機関マスタ"} do |t|
      t.string :code, {null: false, limit: 4, comment: "金融機関コード"}
      t.string :name, {null: false, limit: 40, comment: "金融機関名称"}
      t.string :phonetic, {null: false, limit: 40, comment: "金融機関名称(ﾌﾘｶﾞﾅ)"}

      t.timestamps null: false
    end
    execute "ALTER TABLE banks ADD PRIMARY KEY (code);"
  end
end
