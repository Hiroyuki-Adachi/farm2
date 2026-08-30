class AddIpAddressToQrLoginSessions < ActiveRecord::Migration[8.1]
  def change
    add_column :qr_login_sessions, :ip_address, :string, null: false, default: "", comment: '発行元IPアドレス'

    add_index :qr_login_sessions, [:ip_address, :created_at]
  end
end
