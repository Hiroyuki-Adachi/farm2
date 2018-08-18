class CreateMinutes < ActiveRecord::Migration[5.2]
  def change
    create_table :minutes, comment: "議事録" do |t|
      t.integer :schedule_id, {null: false, default: 0, comment: "作業予定"}
      t.string :pdf_name, {limit: 50, null: true, comment: "PDFファイル名"}
      t.binary :pdf, {null: true, comment: "PDF"}
      t.timestamps
    end
    add_index :minutes, [:schedule_id], {unique: true}
  end
end
