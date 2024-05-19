class CreateIpLists < ActiveRecord::Migration[7.1]
  def change
    create_table :ip_lists, comment: 'IPアドレスリスト' do |t|
      t.string :ip_address, limit: 64, null: false, default: '', comment: 'IP Address'
      t.string :confirmation_token, limit: 64, null: false, default: '', comment: 'トークン'
      t.date :expired_on, null: true, comment: '有効期限'
      t.boolean :white_flag, null: false, default: false, comment: 'ホワイトリストフラグ'
      t.integer :block_count, null: false, default: 0, comment: 'ブロック回数'
      t.string :mail, limit: 255, null: false, default: '', comment: 'メールアドレス'
      t.integer :created_by, null: false, default: 0, comment: '作成者'

      t.timestamps
    end
    add_index :ip_lists, :ip_address, unique: true, name: 'ixdex_ip_lists_on_ip_address'
  end
end
