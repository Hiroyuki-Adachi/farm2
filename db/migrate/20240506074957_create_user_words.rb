class CreateUserWords < ActiveRecord::Migration[7.1]
  def change
    create_table :user_words, comment: '利用者ワード' do |t|
      t.integer :user_id, null: false, comment: "利用者ID"
      t.string :word, limit: 128, null: false, default: '', comment: "ワード"
      t.timestamps
    end
  end
end