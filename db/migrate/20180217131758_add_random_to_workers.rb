class AddRandomToWorkers < ActiveRecord::Migration[4.2]
  def up
    add_column :workers, :token, :string, {null: false, limit: 36, default: '', comment: "アクセストークン"}
    Worker.with_deleted.each do |worker|
      worker.set_token
      worker.save!
    end
    add_index :workers, :token, {unique: true}
  end

  def down
    remove_index :workers, :token
    remove_column :workers, :token
  end
end
