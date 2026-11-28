class CreatePrintTemplatesAndPrintJobs < ActiveRecord::Migration[8.0]
  def change
    create_print_templates
    create_print_jobs
  end

  private

  def create_print_templates
    create_table :print_templates, comment: "定型用紙マスタ" do |t|
      t.references :organization, null: false, foreign_key: true, comment: "組織ID"
      t.string :title, null: false, limit: 40, comment: "用紙名"
      t.binary :pdf_data, null: false, comment: "原紙PDF"
      t.integer :paper_size, null: false, default: 0, comment: "用紙サイズ"
      t.integer :sides, null: false, default: 0, comment: "印刷面"
      t.boolean :active, null: false, default: true, comment: "有効"
      t.integer :display_order, null: false, default: 0, comment: "表示順"

      t.timestamps
    end
  end

  def create_print_jobs
    create_table :print_jobs, comment: "印刷指示" do |t|
      t.references :organization, null: false, foreign_key: true, comment: "組織ID"
      t.references :print_template, null: false, foreign_key: true, comment: "定型用紙ID"
      t.integer :copies, null: false, default: 1, comment: "印刷部数"
      t.integer :status, null: false, default: 0, comment: "状態"
      t.integer :requested_by_id, comment: "印刷指示者(利用者削除時はNULL)"
      t.string :claim_token, comment: "確保時の識別トークン"
      t.datetime :claimed_at, comment: "確保日時"
      t.datetime :finished_at, comment: "完了日時"
      t.integer :cups_job_id, comment: "CUPSジョブ番号"
      t.text :error_message, comment: "エラー内容"

      t.timestamps
    end
    add_index :print_jobs, :requested_by_id
    add_index :print_jobs, [:organization_id, :status]
    add_index :print_jobs, :claim_token, unique: true
    add_foreign_key :print_jobs, :users, column: :requested_by_id, on_delete: :nullify
    add_check_constraint :print_jobs, "copies BETWEEN 1 AND 20", name: "print_jobs_copies_range"
  end
end
