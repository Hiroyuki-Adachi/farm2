class CreateQrLoginSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :qr_login_sessions, comment: 'QRログインセッション' do |t|
      t.string   :token, null: false, limit: 36, comment: 'セッション識別子'
      t.integer  :user_id, null: true, comment: 'ユーザーID'
      t.integer  :status, null: false, default: 0, comment: 'セッション状態'
      t.datetime :expires_at, null: false, comment: 'セッション有効期限'
      t.datetime :consumed_at, null: true, comment: 'セッション使用日時'

      t.timestamps
    end

    add_index :qr_login_sessions, :token, unique: true
  end
end
