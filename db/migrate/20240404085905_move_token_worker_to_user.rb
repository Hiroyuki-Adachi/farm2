class MoveTokenWorkerToUser < ActiveRecord::Migration[7.1]
  def up
    add_column :users, :token, :string, null: false, limit: 36, default: '', comment: "アクセストークン"
    User.all.each do |user|
      user.update!(token: user.worker.token.presence || SecureRandom.uuid)
    end
    add_index :users, :token, unique: true, name: "ix_users_token"
    remove_index :workers, name: "index_workers_on_token"
    remove_column :workers, :token
  end

  def down 
    add_column :workers, :token, :string, null: false, limit: 36, default: '', comment: "アクセストークン"
    User.all.each do |user|
      user.worker.update!(token: user.token.presence || SecureRandom.uuid)
    end
    add_index :workers, :token, unique: true, name: "index_workers_on_token"
    remove_index :users, name: "ix_users_token"
    remove_column :users, :token
  end
end
