# == Schema Information
#
# Table name: task_templates(定型タスク)
#
#  id                              :bigint           not null, primary key
#  active(有効)                    :boolean          default(TRUE), not null
#  annual_month(期日月)            :integer
#  description(説明)               :text             default(""), not null
#  discarded_at(論理削除日時)      :datetime
#  kind(年次/月次)                 :integer          default("annual"), not null
#  monthly_stage(期日週)           :integer          default("w1")
#  months_before_due(事前通知月数) :integer          default(1)
#  office_role(役割)               :integer          default("none"), not null
#  offset(基準からのズレ)          :integer          default(0)
#  priority(優先度)                :integer          default("low"), not null
#  title(タスク名)                 :string(40)       not null
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  organization_id(組織ID)         :bigint           not null
#
# Indexes
#
#  idx_on_kind_annual_month_monthly_stage_5eb8d135fc  (kind,annual_month,monthly_stage)
#  index_task_templates_on_organization_id            (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
require "test_helper"

class TaskTemplateTest < ActiveSupport::TestCase
  setup do
    @org = organizations(:org)
  end

  def build_template(attrs = {})
    TaskTemplate.new({
      organization: @org,
      title: "月次レポート",
      kind: :monthly,
      monthly_stage: :w2,
      priority: :low,
      months_before_due: 1,
      office_role: :none,
      offset: 0,
      active: true
    }.merge(attrs))
  end

  ## ===== バリデーション =====
  test "バリデーション(正常系)" do
    template = build_template
    assert template.valid?
  end

  test "バリデーション(テンプレート名必須)" do
    template = build_template(title: "")
    assert template.invalid?
  end

  test "バリデーション(テンプレート名の長さ)" do
    template = build_template(title: "あ" * 41)
    assert template.invalid?
  end

  test "バリデーション(事前通知月数は0～6)" do
    assert build_template(months_before_due: 0).valid?
    assert build_template(months_before_due: 6).valid?
    t = build_template(months_before_due: 7)
    assert t.invalid?
  end

  test "バリデーション(期日月は1～12)" do
    t = build_template(kind: :annual, annual_month: nil)
    assert t.invalid?

    t = build_template(kind: :annual, annual_month: 13)
    assert t.invalid?

    t = build_template(kind: :annual, annual_month: 12)
    assert t.valid?
  end

  test "バリデーション(基準年からのズレは[-1, 0, 1]のいずれか)" do
    assert build_template(offset: -1).valid?
    assert build_template(offset: 0).valid?
    assert build_template(offset: 1).valid?

    t = build_template(offset: 2)
    assert t.invalid?
  end

  test "コールバック(月次の場合、期日月と事前通知月数をクリア)" do
    t = build_template(kind: :monthly, annual_month: 5, months_before_due: 3)
    t.save!
    assert_nil t.annual_month
    assert_equal 1, t.months_before_due
  end

  test "期日計算(月末)" do
    t = build_template(monthly_stage: :month_end)
    d = t.due_on_for(year: 2025, month: 2)
    assert_equal Date.new(2025, 2, 28), d
  end

  test "期日計算(週末)" do
    t = build_template(monthly_stage: :w1)
    assert_equal 6, Date.new(2025, 2, 1).wday

    d1 = t.due_on_for(year: 2025, month: 2)
    assert_equal Date.new(2025, 2, 1 + ((6 - Date.new(2025,2,1).wday) % 7)), Date.new(2025,2,1) + ((6 - Date.new(2025,2,1).wday) % 7) # sanity
    assert_equal 1, d1.day # 2025-02 の最初の土曜は 1日

    t2 = build_template(monthly_stage: :w3)
    d3 = t2.due_on_for(year: 2025, month: 2)
    assert_equal 15, d3.day # 2025-02 の第3土曜は 15日
  end

  test "due_on_candidates_for(月次)" do
    t = build_template(monthly_stage: :w2, months_before_due: 1)
    due = t.due_on_for(year: 2025, month: 2)  # 第2土曜 2025-02-08
    today = (due << 1)                        # 1ヶ月前
    list = t.due_on_candidates_for(today: today)
    assert_includes list, due
  end

  test "due_on_candidates_for(年次)(該当あり)" do
    t = build_template(kind: :annual, annual_month: 3, months_before_due: 2)
    # 今年 3月の due_on を計算して、2ヶ月前が today になるかをチェック
    due = t.due_on_for(year: 2025, month: 3)
    today = (due << 2)
    list = t.due_on_candidates_for(today: today)
    assert_includes list, due
  end

  test "due_on_candidates_for(年次)(該当なし)" do
    t = build_template(kind: :annual, annual_month: nil)
    assert_equal [], t.due_on_candidates_for(today: Date.new(2025,1,1))
  end

  test "destroy_or_archive!(タスクあり)" do
    t = TaskTemplate.create!(build_template.attributes.except("id"))
    # tasks.exists? を true にスタブ
    t.tasks.stubs(:exists?).returns(true)

    t.destroy_or_archive!
    t.reload
    assert_not t.active
    assert t.discarded?
    assert_not t.destroyed?
  end

  test "destroy_or_archive!(タスクなし)" do
    t = TaskTemplate.create!(build_template.attributes.except("id"))
    t.tasks.stubs(:exists?).returns(false)

    t.destroy_or_archive!
    assert t.destroyed?
  end

  test "create_task(論理削除)" do
    t = TaskTemplate.create!(build_template.attributes.except("id"))
    t.discard
    assert_nil t.create_task(due_on: Date.new(2025,2,1))
  end

  test "create_task(無効)" do
    t = TaskTemplate.create!(build_template(active: false).attributes.except("id"))
    assert_nil t.create_task(due_on: Date.new(2025,2,1))
  end

  test "create_task(同じタスクが存在する場合)" do
    t = TaskTemplate.create!(build_template.attributes.except("id"))
    t.stubs(:same_task_exists?).returns(true)
    assert_nil t.create_task(due_on: Date.new(2025,2,1))
  end

  test "create_task(正常系)" do
    t = TaskTemplate.create!(build_template(kind: :monthly, title: "年次点検", offset: 0).attributes.except("id"))
    t.stubs(:same_task_exists?).returns(false)

    due_on = Date.new(2025, 2, 15)

    Task.expects(:create!).with do |attrs|
      rel = attrs[:template] || attrs[:task_template] # 念のため両対応

      attrs[:title].include?("年") && 
        attrs[:title].include?("年次点検") &&
        attrs[:description] == t.description &&
        attrs[:due_on] == due_on &&
        attrs[:priority] == t.priority &&
        attrs[:office_role] == t.office_role && 
        attrs[:task_status_id].to_i == TaskStatus::TO_DO.id &&
        rel == t
    end.returns(:task_double)

    assert_equal :task_double, t.create_task(due_on: due_on)
  end

  test "same_task_exists?(月次)" do
    t = TaskTemplate.create!(build_template(kind: :monthly).attributes.except("id"))
    mock_assoc = mock
    t.stubs(:tasks).returns(mock_assoc)
    mock_assoc.expects(:exists?).with(has_entries(due_on: Date.new(2025,2,1).all_month)).returns(true)

    assert t.same_task_exists?(due_on: Date.new(2025,2,1))
  end

  test "same_task_exists?(年次)(該当あり)" do
    t = TaskTemplate.create!(build_template(kind: :annual, annual_month: 3).attributes.except("id"))
    System.expects(:get_system).with(Date.new(2025,3,10), t.organization_id).returns(nil)
    assert t.same_task_exists?(due_on: Date.new(2025,3,10))
  end

  test "same_task_exists?(年次)(該当なし)" do
    t = TaskTemplate.create!(build_template(kind: :annual, annual_month: 3).attributes.except("id"))
    sys = stub(start_date: Date.new(2025,4,1), end_date: Date.new(2026,3,31))
    System.expects(:get_system).with(Date.new(2025,5,1), t.organization_id).returns(sys)

    mock_assoc = mock
    t.stubs(:tasks).returns(mock_assoc)
    mock_assoc.expects(:exists?).with(due_on: sys.start_date..sys.end_date).returns(false)

    assert_equal false, t.same_task_exists?(due_on: Date.new(2025,5,1))
  end
end
