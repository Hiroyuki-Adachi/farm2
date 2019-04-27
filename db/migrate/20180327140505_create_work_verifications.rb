class CreateWorkVerifications < ActiveRecord::Migration[4.2]
  def change
    create_table :work_verifications, comment: "日報検証" do |t|
      t.integer :work_id,       {comment: "作業"}
      t.integer :worker_id,     {comment: "作業者"}

      t.timestamps null: false
    end
    add_index :work_verifications, [:work_id, :worker_id], {unique: true}
  end
end
