class CreateSorimachiJournals < ActiveRecord::Migration[6.0]
  def change
    create_table :sorimachi_journals, comment: "ソリマチ仕訳" do |t|
      t.integer  :term,    limit: 4, null: false, comment: "年度(期)"

      t.integer  :line,    null: false, comment: "行番号"
      t.integer  :detail,  null: false, comment: "明細番号"
      t.date     :accounted_on, null: true, comment: "仕訳日"
      t.integer   :code01,  null: false, limit: 4, comment: "コード0-1"
      t.integer   :code02,  null: false, limit: 4, comment: "コード0-2"
      t.integer   :code03,  null: false, limit: 4, comment: "コード0-3"
      t.integer   :code04,  null: false, limit: 4, comment: "コード0-4"
      t.integer   :code05,  null: false, limit: 4, comment: "コード0-5"
      t.integer   :code06,  null: false, limit: 4, comment: "コード0-6"
      t.integer   :code07,  null: false, limit: 4, comment: "コード0-7"
      t.decimal  :amount1, null: false, default: 0, scale: 2, precision: 11, comment: "金額1"
      t.integer   :code11,  null: false, limit: 6, comment: "コード1-1"
      t.integer   :code12,  null: false, limit: 6, comment: "コード1-2"
      t.integer   :code13,  null: false, limit: 6, comment: "コード1-3"
      t.integer   :code14,  null: false, limit: 6, comment: "コード1-4"
      t.integer   :code15,  null: false, limit: 6, comment: "コード1-5"
      t.integer   :code16,  null: false, limit: 6, comment: "コード1-6"
      t.integer   :code17,  null: false, limit: 6, comment: "コード1-7"
      t.integer   :code18,  null: false, limit: 6, comment: "コード1-8"
      t.decimal  :amount2, null: false, default: 0, scale: 2, precision: 11, comment: "金額2"
      t.integer   :code21,  null: false, limit: 1, comment: "コード2-1"
      t.string   :remark1, null: false, limit: 50, comment: "備考1"
      t.string   :remark2, null: false, limit: 50, comment: "備考2"
      t.string   :remark3, null: false, limit: 50, comment: "備考3"
      t.string   :code31,  null: false, limit: 1, comment: "コード3-1"
      t.decimal  :amount3, null: false, default: 0, scale: 2, precision: 11, comment: "金額3"
      t.string   :remark4, null: false, limit: 50, comment: "備考4"

      t.timestamps
    end
    add_index :sorimachi_journals, [:term, :line, :detail], unique: true, name: "sorimachi_journals_2nd"
  end
end
