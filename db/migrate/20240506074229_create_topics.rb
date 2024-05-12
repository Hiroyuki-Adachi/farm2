class CreateTopics < ActiveRecord::Migration[7.1]
  def change
    create_table :topics, comment: 'トピック' do |t|
      t.string :url, limit: 512, null: false, default: '', comment: "URL"
      t.string :title, limit: 512, null: false, default: '', comment: "タイトル"
      t.date :posted_on, null: false, comment: "投稿日"
      t.text :content, null: true, comment: "内容"
      t.timestamps
    end
    add_index :topics, :url, unique: true
  end
end
