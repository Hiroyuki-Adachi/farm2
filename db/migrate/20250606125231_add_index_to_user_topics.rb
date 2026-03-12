class AddIndexToUserTopics < ActiveRecord::Migration[8.0]
  def change
    add_index :user_topics, [:user_id, :topic_id], unique: true, name: 'ix_user_topics_user_id_topic_id'
  end
end
