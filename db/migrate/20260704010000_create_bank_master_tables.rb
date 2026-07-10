class CreateBankMasterTables < ActiveRecord::Migration[8.1]
  def change
    create_banks
    create_bank_branches
  end

  private

  def create_banks
    create_table :banks, comment: "金融機関マスタ" do |t|
      t.string :code, limit: 4, null: false, comment: "金融機関コード"
      t.string :name, limit: 40, null: false, comment: "金融機関名称"
      t.string :kana, limit: 40, default: "", null: false, comment: "金融機関名称(カナ)"

      t.timestamps
    end

    add_index :banks, :code, unique: true
  end

  def create_bank_branches
    create_table :bank_branches, comment: "支店マスタ" do |t|
      t.string :bank_code, limit: 4, null: false, comment: "金融機関コード"
      t.string :code, limit: 3, null: false, comment: "支店コード"
      t.string :name, limit: 40, null: false, comment: "支店名称"
      t.string :kana, limit: 40, default: "", null: false, comment: "支店名称(カナ)"

      t.timestamps
    end

    add_index :bank_branches, [:bank_code, :code], unique: true, name: "index_bank_branches_on_bank_code_and_code"
    add_foreign_key :bank_branches, :banks, column: :bank_code, primary_key: :code
  end
end
