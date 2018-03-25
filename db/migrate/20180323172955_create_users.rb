class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users, comment: "利用者マスタ" do |t|
      t.string :login_name, null: false, limit: 12, comment: "ログイン名"
      t.string :password_digest, null: false, limit: 128, comment: "パスワード"
      t.integer :worker_id, comment: "作業者"

      t.timestamps null: false
    end
    add_index :users, :login_name, unique: true
    add_index :users, :worker_id, unique: true
    insert_data
  end

  def down
    drop_table :users
  end

  private

  def insert_data
    Worker.where.not(mobile: '').each do |worker|
      next if worker.mobile.blank?

      login_name = worker.mobile.delete('-')
      password = worker.home.address1.gsub(/[^\d4]/, "")
      User.create!(login_name: login_name, password: password, password_confirmation: password, worker_id: worker.id)
    end
  end
end
