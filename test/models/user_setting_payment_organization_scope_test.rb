require "test_helper"

class UserSettingPaymentOrganizationScopeTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:org)
    @other_organization = organizations(:org2)
    @other_user = users(:user_admin_org2)
    @other_worker = workers(:worker_other_org)
  end

  test "親レコードの組織でユーザー周辺設定を絞り込む" do
    assert_includes User.for_organization(@other_organization), @other_user
    assert_not_includes User.for_organization(@organization), @other_user
    create_other_user_settings.each { |record| assert_scoped(record) }
  end

  test "親バッチの組織で全銀支払先と明細を絞り込む" do
    batch = create_batch(@other_organization, 2099)
    payment = batch.zengin_payments.create!(worker: @other_worker)
    detail = payment.zengin_payment_details.create!(
      payment_type: :other,
      source_kind: :manual,
      amount: 100,
      original_amount: 100
    )

    assert_scoped(payment)
    assert_scoped(detail)
  end

  test "全銀支払先には親バッチと同じ組織の作業者だけを指定できる" do
    batch = create_batch(@organization, 2098)
    payment = batch.zengin_payments.build(worker: @other_worker)

    assert_not payment.valid?
    assert payment.errors.added?(:worker_id, "は支払バッチと同じ組織の作業者を指定してください。")
  end

  private

  def create_other_user_settings
    schedule = Schedule.create!(
      organization: @other_organization,
      term: 2015,
      worked_at: Date.new(2015, 5, 1),
      work_kind: work_kinds(:work_kinds2),
      name: "別組織会議",
      work_flag: false,
      created_by: @other_worker.id
    )
    [
      Minute.create!(schedule: schedule, pdf_name: "OTHER.PDF", pdf: "other"),
      CalendarWorkKind.create!(
        user: @other_user, work_kind: work_kinds(:work_kind_taue), text_color: "#123456"
      ),
      UserWord.create!(user: @other_user, word: "phase18-org2"),
      UserTopic.create!(user: @other_user, topic: topics(:topic1), word: "phase18-org2"),
      WebPushSubscription.create!(
        user: @other_user, endpoint: "https://example.com/push/phase18-org2",
        p256dh: "p256dh-key", auth: "auth-key"
      )
    ]
  end

  def create_batch(organization, term)
    ZenginPaymentBatch.create!(
      organization: organization,
      term: term,
      fixed_at: Date.new(term, 12, 31)
    )
  end

  def assert_scoped(record)
    assert record.class.for_organization(@other_organization).exists?(record.id), record.class.name
    assert_not record.class.for_organization(@organization).exists?(record.id), record.class.name
  end
end
