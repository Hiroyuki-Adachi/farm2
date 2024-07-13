class CreateUserTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :user_tokens,  comment: '利用者トークン' do |t|
      t.integer :user_id, null: false, comment: "利用者ID"
      t.string :token, limit: 36, null: false, default: '', comment: "トークン(UUID)"
      t.datetime :expires_at, null: false, comment: "有効期限"
      t.timestamps
    end
    add_index :user_tokens, [:user_id], unique: true
  end
end
