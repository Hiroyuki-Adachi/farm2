class AddMailToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :mail, :string, limit: 255, null: false, default: '', comment: 'メールアドレス'
    add_column :users, :mail_confirmed_at, :datetime, null: true, comment: 'メールアドレス確認日時'
    add_column :users, :mail_confirmation_token, :string, limit: 64, null: true, comment: 'メールアドレス確認トークン'
    add_column :users, :mail_confirmation_expired_at, :datetime, null: true, comment: 'メールアドレス確認有効期限'
  end
end
