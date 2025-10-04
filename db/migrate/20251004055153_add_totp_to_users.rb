class AddTotpToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :otp_enabled, :boolean, null: false, default: false, comment: "2段階認証フラグ"
    add_column :users, :otp_last_used_at, :datetime, null: true, comment: "2段階認証 最終使用日時"
    add_column :users, :otp_secret_ciphertext, :string, null: true, comment: "2段階認証 秘密鍵"
  end
end
