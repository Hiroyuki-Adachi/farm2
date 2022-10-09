class CreateWorkTypeTerms < ActiveRecord::Migration[7.0]
  def change
    create_table :work_type_terms, comment: "作業分類年度別マスタ" do |t|
      t.integer :term,         limit: 4, null: false, comment: "年度(期)"
      t.integer :work_type_id, null: false, comment: "作業分類"
      t.string  :bg_color,     limit: 8, null: true, comment: "背景色"

      t.timestamps
    end
    add_index :work_type_terms, [:term, :work_type_id], unique: true, name: "work_type_terms_2nd"

    bg_colors = ActiveRecord::Base.connection.select_all("SELECT id, bg_color FROM work_types").rows.to_h

    Work.select(:term, :work_type_id).distinct.each do |work|
      WorkTypeTerm.create(
        term: work.term,
        work_type_id: work.work_type_id,
        bg_color: bg_colors[work.work_type_id]
      )
    end
  end
end
