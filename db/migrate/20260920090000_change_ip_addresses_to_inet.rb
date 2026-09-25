class ChangeIpAddressesToInet < ActiveRecord::Migration[8.1]
  def up
    change_column :ip_lists, :ip_address, :inet, using: "ip_address::inet", default: nil, null: false
    change_column :qr_login_sessions, :ip_address, :inet, using: "ip_address::inet", default: nil, null: false
  end

  def down
    # `ip_address::text` would append "/32"、"/128" のprefix。host()で単一アドレス表記に戻す。
    change_column :ip_lists, :ip_address, :string, limit: 64, using: "host(ip_address)", default: "", null: false
    change_column :qr_login_sessions, :ip_address, :string, using: "host(ip_address)", default: "", null: false
  end
end
