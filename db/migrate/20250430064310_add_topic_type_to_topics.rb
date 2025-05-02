class AddTopicTypeToTopics < ActiveRecord::Migration[8.0]
  def change
    add_column :topics, :topic_type_id, :integer, null: false, default: 0, comment: "トピック種別"
    add_column :user_words, :pc_flag, :boolean, null: false, default: true, comment: "パソコンフラグ"
    add_column :user_words, :sp_flag, :boolean, null: false, default: true, comment: "スマートフォンフラグ"
    add_column :user_words, :line_flag, :boolean, null: false, default: false, comment: "LINEフラグ"
    add_column :user_topics, :pc_flag, :boolean, null: false, default: true, comment: "パソコンフラグ"
    add_column :user_topics, :sp_flag, :boolean, null: false, default: true, comment: "スマートフォンフラグ"
    add_column :user_topics, :line_flag, :boolean, null: false, default: false, comment: "LINEフラグ"

    TopicType.all.each do |topic_type|
      Topic.where("url LIKE ?", "#{topic_type.url}%").find_each do |topic|
        topic.update(topic_type_id: topic_type.id)
      end
    end
  end
end
