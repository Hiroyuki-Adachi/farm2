class CreateUserWords < ActiveRecord::Migration[7.1]
  def change
    create_table :user_words, comment: '利用者ワード' do |t|
      t.integer :user_id, null: false, comment: "利用者ID"
      t.string :word, limit: 128, null: false, default: '', comment: "ワード"
      t.timestamps
    end
    add_index :user_words, [:user_id, :word], unique: true, name: "index_user_words_on_word_by_user_id"
    add_index :user_words, [:word], name: "index_user_words_on_word"
  end
end
