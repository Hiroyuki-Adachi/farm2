class AddLoginLockFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :failed_login_attempts, :integer, default: 0, null: false, comment: "ログイン失敗回数"
    add_column :users, :locked_at, :datetime, comment: "ログインロック日時"
  end
end
