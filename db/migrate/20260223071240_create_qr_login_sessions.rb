class CreateQrLoginSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :qr_login_sessions, comment: 'QRログインセッション' do |t|
      t.string   :token, null: false, comment: 'セッション識別子'
      t.integer  :user_id, null: false, comment: 'ユーザーID'
      t.integer  :status, null: false, default: 0, comment: 'セッション状態（0: 有効, 1: 使用済み, 2: 期限切れ）'
      t.datetime :expires_at, null: false, comment: 'セッション有効期限'
      t.integer  :approved_user_id, comment: '承認したユーザーID'

      t.timestamps
    end

    add_index :qr_login_sessions, :token, unique: true
  end
end
