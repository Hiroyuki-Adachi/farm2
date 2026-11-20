# 参照する作業分類(work_type_id)の組織が、レコードの組織と一致することを検証する。
#
# DB制約にはせずアプリ側で保証する(#1272)。作業分類か組織の決め手となる属性が
# 変わる保存だけを検証し、変更のない既存データの更新は妨げない。
#
#   validates_work_type_organization organization: :organization_id
#   validates_work_type_organization organization: -> { land&.organization_id }, watch: [:land_id]
module WorkTypeOrganizationValidation
  extend ActiveSupport::Concern

  MESSAGE = "は同じ組織の作業分類を選択してください".freeze

  class_methods do
    # organization: レコードの組織IDを返すメソッド名、または Proc
    # watch: 変わったときに検証し直す、組織の決め手となる属性
    def validates_work_type_organization(organization:, watch: [:organization_id])
      watched = ["work_type_id", *watch.map(&:to_s)]

      validate if: -> { new_record? || watched.any? { |attribute| will_save_change_to_attribute?(attribute) } } do
        validate_work_type_organization(organization)
      end
    end
  end

  private

  def validate_work_type_organization(organization)
    return if work_type_id.blank?

    organization_id = organization.respond_to?(:call) ? instance_exec(&organization) : send(organization)
    return if organization_id.blank?

    work_type_organization_id = loaded_work_type_organization_id ||
                                WorkType.with_discarded.where(id: work_type_id).pick(:organization_id)
    return if work_type_organization_id.nil? || work_type_organization_id == organization_id

    errors.add(:work_type_id, MESSAGE)
  end

  # work_type をすでに読み込んでいる(代入して保存するなど)ときは、追加のクエリを発行しない。
  # 関連に論理削除の除外条件があるモデルもあるため、読み込み済みでなければDBから引く。
  def loaded_work_type_organization_id
    association = association(:work_type)
    return unless association.loaded?

    work_type = association.target
    work_type.organization_id if work_type&.id == work_type_id
  end
end
