class CreateQrLoginSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :qr_login_sessions do |t|
      t.string :token, null: false
      t.datetime :expires_at, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :qr_login_sessions, :token, unique: true
    add_index :qr_login_sessions, :expires_at
    add_index :qr_login_sessions, :status
  end
end
