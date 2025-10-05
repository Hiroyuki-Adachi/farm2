class CreateTrustedDevices < ActiveRecord::Migration[8.0]
  def change
    create_table :trusted_devices do |t|
      t.references :user, null: false, foreign_key: true, comment: 'ユーザーID'
      t.string :token_digest, limit: 128, null: false, comment: 'トークンのダイジェスト'
      t.string :ua_hash, limit: 128, null: false, comment: 'ユーザーエージェントのハッシュ'
      t.string :device_name, limit: 64, null: false, default: '', comment: 'デバイス名'
      t.string :ip_address, limit: 64, null: false, comment: 'IPアドレス'
      t.datetime :last_used_at, null: false, comment: '最終使用日時'
      t.timestamps
    end
    add_index :trusted_devices, :token_digest, unique: true
  end
end
