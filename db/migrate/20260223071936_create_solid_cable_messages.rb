class CreateSolidCableMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :solid_cable_messages, comment: 'Solid Cableメッセージ' do |t|
      t.binary  :channel,      limit: 1024,        null: false, comment: 'チャンネル'
      t.binary  :payload,      limit: 536_870_912, null: false, comment: 'ペイロード'
      t.integer :channel_hash, limit: 8,           null: false, comment: 'チャンネルハッシュ'
      t.datetime :created_at,  null: false, comment: '作成日時'
    end

    add_index :solid_cable_messages, :channel
    add_index :solid_cable_messages, :channel_hash
    add_index :solid_cable_messages, :created_at
  end
end
