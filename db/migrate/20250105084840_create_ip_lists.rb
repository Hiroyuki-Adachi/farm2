class CreateIpLists < ActiveRecord::Migration[7.2]
  def change
    create_table :ip_lists, comment: 'IPアドレスリスト' do |t|
      t.string :ip_address, limit: 64, null: false, default: '', comment: 'IP Address'
      t.string :hashed_token, limit: 64, null: false, default: '', comment: 'ハッシュ化トークン'
      t.date :expired_on, null: true, comment: '有効期限'
      t.boolean :white_flag, null: false, default: false, comment: 'ホワイトリストフラグ'
      t.integer :block_count, null: false, default: 0, comment: 'ブロック回数'
      t.string :mail, limit: 255, null: false, default: '', comment: 'メールアドレス'
      t.integer :created_by, null: false, default: 0, comment: '作成者'
      t.datetime :confirmation_expired_at, null: true, comment: '確認有効期限'

      t.timestamps
    end
    add_index :ip_lists, :ip_address, unique: true, name: 'ixdex_ip_lists_on_ip_address'
  end
end
