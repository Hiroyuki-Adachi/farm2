class CreateUserTopics < ActiveRecord::Migration[7.1]
  def change
    create_table :user_topics, comment: '利用者トピック' do |t|
      t.integer :user_id, null: false, comment: "利用者ID"
      t.integer :topic_id, null: false, comment: "トピックID"
      t.string :word, limit: 128, null: false, default: '', comment: "ワード"
      t.boolean :read_flag, null: false, default: false, comment: "既読フラグ"
      
      t.timestamps
    end
  end
end
