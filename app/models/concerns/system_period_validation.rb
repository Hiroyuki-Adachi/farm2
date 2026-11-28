# 日付が、レコードの組織と年度(term)に対応する System の期首〜期末に入っていることを検証する(#1351)。
#
# 画面の date_field の min/max だけでは、リクエストを直接送れば期外の日付で保存できるため、
# サーバー側でも検証する。新規作成時と、日付・年度・組織の決め手となる属性が変わる保存だけを検証し、
# 変更のない既存データの更新は妨げない。
#
#   validates_within_system_period :worked_at, organization: :organization_id
#   validates_within_system_period :carried_on, organization: -> { home&.organization_id }, watch: [:home_id]
module SystemPeriodValidation
  extend ActiveSupport::Concern

  class_methods do
    # date_attribute: 期内であるべき日付の属性
    # organization: レコードの組織IDを返すメソッド名、または Proc
    # watch: 変わったときに検証し直す、組織の決め手となる属性
    def validates_within_system_period(date_attribute, organization:, watch: [:organization_id])
      watched = [date_attribute.to_s, "term", *watch.map(&:to_s)]

      validate if: -> { new_record? || watched.any? { |attribute| will_save_change_to_attribute?(attribute) } } do
        validate_within_system_period(date_attribute, organization)
      end
    end
  end

  private

  def validate_within_system_period(date_attribute, organization)
    date = send(date_attribute)
    organization_id = organization.respond_to?(:call) ? instance_exec(&organization) : send(organization)
    return if date.blank? || term.blank? || organization_id.blank?

    system = System.find_by(organization_id: organization_id, term: term)
    return if system && (system.start_date..system.end_date).cover?(date)

    errors.add(date_attribute, "は#{term}年度の期間内(#{system_period_label(system)})の日付を入力してください")
  end

  def system_period_label(system)
    return "年度が未登録" unless system

    "#{I18n.l(system.start_date)}〜#{I18n.l(system.end_date)}"
  end
end
