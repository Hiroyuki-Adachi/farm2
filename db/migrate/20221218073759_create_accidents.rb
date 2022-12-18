class CreateAccidents < ActiveRecord::Migration[7.0]
  def change
    create_table :accidents, comment: 'ヒヤリハット' do |t|
      t.integer :investigator_id, null: false, default: 0, comment: "調査責任者ID"
      t.string  :informant_name, null: false, limit: 40, default: "", comment: "情報提供者"
      t.integer :accident_type_id, null: false, default: 0, comment: "ヒヤリハット種別ID"
      t.integer :work_id, null: false, comment: "対象日報"
      t.integer :audience_id, null: false, default: 0, comment: "対象者ID"
      t.point   :location,  null: true, comment: "場所"
      t.text    :content, null: false, default: "", comment: "内容"
      t.text    :problem, null: false, default: "", comment: "問題点の考察"
      t.text    :solving, null: false, default: "", comment: "問題解決の考察"
      t.text    :result,  null: false, default: "", comment: "改善の結果"

      t.timestamps
    end
  end
end
