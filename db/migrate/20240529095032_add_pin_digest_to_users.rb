class AddPinDigestToUsers < ActiveRecord::Migration[7.1]
  def up
    add_column :users, :pin_digest, :string, limit: 128, null: false, default: "", comment: "PIN"
    User.all.each do |user|
      next if user.pin_digest.present?
      next unless user.worker.present?
      next unless user.worker.mobile.present?
      next unless user.worker.mobile.split('-').length == 3
      next unless user.worker.mobile.split('-')[2].length == 4
      user.update(pin_digest: BCrypt::Password.create(user.worker.mobile.split('-')[2], cost: 4))
    end
  end

  def down
    remove_column :users, :pin_digest
  end
end
