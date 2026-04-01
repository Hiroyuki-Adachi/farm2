class CreateWebPushSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :web_push_subscriptions, comment: "WebPush購読情報" do |t|
      t.references :user, null: false, foreign_key: true, comment: "利用者"
      t.text :endpoint, null: false, comment: "Push endpoint"
      t.string :p256dh, null: false, comment: "公開鍵"
      t.string :auth, null: false, comment: "認証鍵"
      t.datetime :expiration_time, comment: "購読有効期限"
      t.string :user_agent, comment: "利用端末"
      t.datetime :last_used_at, comment: "最終送信日時"

      t.timestamps
    end

    add_index :web_push_subscriptions, :endpoint, unique: true
    add_index :web_push_subscriptions, [:user_id, :endpoint], unique: true
  end
end
