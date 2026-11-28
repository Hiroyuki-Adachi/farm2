require "test_helper"

# == Schema Information
#
# Table name: print_jobs(印刷指示)
#
#  id                                              :bigint           not null, primary key
#  claim_token(確保時の識別トークン)               :string
#  claimed_at(確保日時)                            :datetime
#  copies(印刷部数)                                :integer          default(1), not null
#  error_message(エラー内容)                       :text
#  finished_at(完了日時)                           :datetime
#  status(状態)                                    :integer          default("waiting"), not null
#  created_at                                      :datetime         not null
#  updated_at                                      :datetime         not null
#  cups_job_id(CUPSジョブ番号)                     :integer
#  organization_id(組織ID)                         :bigint           not null
#  print_template_id(定型用紙ID)                   :bigint           not null
#  requested_by_id(印刷指示者(利用者削除時はNULL)) :integer
#
# Indexes
#
#  index_print_jobs_on_claim_token                 (claim_token) UNIQUE
#  index_print_jobs_on_organization_id             (organization_id)
#  index_print_jobs_on_organization_id_and_status  (organization_id,status)
#  index_print_jobs_on_print_template_id           (print_template_id)
#  index_print_jobs_on_requested_by_id             (requested_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (print_template_id => print_templates.id)
#  fk_rails_...  (requested_by_id => users.id) ON DELETE => nullify
#
class PrintJobTest < ActiveSupport::TestCase
  setup do
    @template = print_templates(:print_template_daily)
    @user = users(:users1)
  end

  test "初期値は1部・待機中" do
    job = PrintJob.new
    assert_equal 1, job.copies
    assert job.status_waiting?
  end

  test "部数は1〜20部" do
    [1, PrintJob::MAX_COPIES].each do |copies|
      assert build_job(copies: copies).valid?, "#{copies}部が登録できない"
    end
    [0, PrintJob::MAX_COPIES + 1, 1.5, nil].each do |copies|
      assert_not build_job(copies: copies).valid?, "#{copies.inspect}部が登録できてしまう"
    end
  end

  test "DBでも部数の範囲を制限する" do
    job = build_job
    job.save!
    assert_raises(ActiveRecord::StatementInvalid) do
      job.update_column(:copies, PrintJob::MAX_COPIES + 1) # rubocop:disable Rails/SkipsModelValidations
    end
  end

  test "他組織の定型用紙は指定できない" do
    job = build_job(print_template: print_templates(:print_template_other_org))
    assert_not job.valid?
    assert job.errors.added?(:print_template, :other_organization)
  end

  test "他組織の利用者は印刷指示者にできない" do
    other = users(:users1).dup
    other.organization_id = 2
    job = build_job(requested_by: other)
    assert_not job.valid?
    assert job.errors.added?(:requested_by, :other_organization)
  end

  test "作成時は印刷指示者が必須" do
    job = build_job(requested_by: nil)
    assert_not job.valid?
    assert job.errors.added?(:requested_by, :blank)
  end

  test "印刷指示者を削除しても印刷指示は残る" do
    job = build_job
    job.save!
    users(:users1).destroy!
    job.reload
    assert_nil job.requested_by_id
    assert job.valid?
  end

  test "未処理は待機中と処理中" do
    job = build_job
    job.save!
    PrintJob.statuses.each_key do |status|
      job.update!(status: status)
      assert_equal PrintJob::PENDING_STATUSES.include?(status), PrintJob.pending.exists?(job.id), status
    end
  end

  test "無効な定型用紙では新しく作成できない" do
    job = build_job(print_template: print_templates(:print_template_inactive))
    assert_not job.valid?
    assert job.errors.added?(:print_template, :inactive)
  end

  test "作成後に定型用紙を無効にしても印刷指示は更新できる" do
    job = build_job
    job.save!
    @template.update!(active: false)
    assert job.reload.update(status: :submitted)
  end

  test "待機中の印刷指示は取り消せる" do
    job = build_job
    job.save!
    freeze_time do
      assert job.cancel!
      job.reload
      assert job.status_canceled?
      assert_equal Time.current, job.finished_at
    end
  end

  test "待機中以外の印刷指示は取り消せない" do
    job = build_job
    job.save!
    (PrintJob.statuses.keys - ["waiting"]).each do |status|
      job.update!(status: status, finished_at: nil)
      assert_not job.cancel!, status
      assert_equal status, job.reload.status
      assert_nil job.finished_at
    end
  end

  test "取消の直前に別の処理で確保された場合は取り消さない" do
    job = build_job
    job.save!
    stale = PrintJob.find(job.id)
    job.update!(status: :claimed)
    assert_not stale.cancel!
    assert job.reload.status_claimed?
  end

  private

  def build_job(**attrs)
    PrintJob.new({ organization_id: 1, print_template: @template, requested_by: @user, copies: 1 }.merge(attrs))
  end
end
