class CreateQrLoginRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :qr_login_requests, comment: 'QRログインリクエスト' do |t|
      t.string   :token, limit: 64, null: false, comment: "一時トークン"
      t.datetime :approved_at, null: true, comment: "承認日時"
      t.bigint   :approved_by_id, null: true, comment: "承認者ID"
      t.datetime :expires_at, null: false, comment: "有効期限"
      t.datetime :used_at, null: true, comment: "確定日時"
      t.string   :pc_nonce, limit: 64, null: false, default: '', comment: "PC用ノンス"
      t.text     :user_agent, null: false, default: '', comment: "ユーザーエージェント"
      t.string   :ip, limit: 45, null: false, default: '', comment: 'IPアドレス'
      t.timestamps
    end

    add_index :qr_login_requests, :token, unique: true
    add_index :qr_login_requests, :approved_by_id
    add_index :qr_login_requests, :expires_at
    add_index :qr_login_requests, :used_at
  end
end
