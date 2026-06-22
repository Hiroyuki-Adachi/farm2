class CreateLandTermMarks < ActiveRecord::Migration[8.1]
  def change
    create_table :land_term_marks, comment: "土地年度別記号" do |t|
      t.references :land, null: false, foreign_key: true, index: false, comment: "土地"
      t.integer :term, null: false, comment: "年度(期)"
      t.string :mark, limit: 10, null: false, comment: "記号"

      t.timestamps
    end

    add_index :land_term_marks, [:land_id, :term], unique: true
    remove_column :lands, :broccoli_mark, :string, limit: 1, comment: "ブロッコリ記号"
  end
end
