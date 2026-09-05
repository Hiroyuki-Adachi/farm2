class AddMailFlagToUserTopicsAndUserWords < ActiveRecord::Migration[8.1]
  def change
    add_column :user_topics, :mail_flag, :boolean, null: false, default: false, comment: "メールフラグ"
    add_column :user_words, :mail_flag, :boolean, null: false, default: false, comment: "メールフラグ"
  end
end
