class AddAuthInfoToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :google_salt,    :string, limit: 32, null: false, default: '', comment: "google salt"
    add_column :users, :google_secret,  :string, limit: 32, null: true, default: nil, comment: "google secret"
    add_column :users, :email,          :string, limit: 50, null: false, default: '', comment: "e-mail"

    User.all.each do |user|
      if user&.worker&.pc_mail.present?
        user.email = user.worker.pc_mail
        user.save!
        user.set_google_secret 
      end
    end
  end
end
