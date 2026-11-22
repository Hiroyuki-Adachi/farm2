# 薬剤登録画面で選んだ作業地ごとの薬剤グループ番号を保存する(#1352)。
# 対象はその作業の作業地に限り、ほかの作業の作業地 ID が混じっていれば1件も書き込まずに拒否する。
class Work::ChemicalGroupNoRegistrar
  def initialize(work, params, max_group_no:)
    @work = work
    @params = params
    @max_group_no = max_group_no
  end

  def call
    return if @params.blank?

    group_nos = parse_params
    work_lands = find_work_lands!(group_nos.keys)
    group_nos.each { |id, group_no| validate_group_no!(work_lands[id], group_no) }

    now = Time.current
    group_nos.group_by { |_id, group_no| group_no }.each do |group_no, pairs|
      # 作業地の関連は表示順の order を持つため、関連を経由せずに更新する。
      WorkLand.where(work_id: @work.id, id: pairs.map(&:first))
        .update_all(chemical_group_no: group_no, updated_at: now) # rubocop:disable Rails/SkipsModelValidations
    end
  end

  private

  # { 作業地ID(Integer) => 薬剤グループ番号(Integer または nil) }
  def parse_params
    raise ActionController::BadRequest, "work_lands must be a hash" unless @params.respond_to?(:to_unsafe_h)

    @params.to_unsafe_h.each_with_object({}) do |(id, value), result|
      work_land_id = to_integer(id)
      if work_land_id.nil? || result.key?(work_land_id)
        raise ActiveRecord::RecordNotFound, "WorkLand #{id} is not found"
      end

      result[work_land_id] = to_integer(value)
    end
  end

  def to_integer(value)
    return unless value.is_a?(String) || value.is_a?(Integer)

    Integer(value.to_s, 10, exception: false)
  end

  def find_work_lands!(ids)
    work_lands = WorkLand.where(work_id: @work.id, id: ids).index_by(&:id)
    missing = ids - work_lands.keys
    raise ActiveRecord::RecordNotFound, "WorkLand #{missing.join(',')} is not found in Work #{@work.id}" if missing.any?

    work_lands
  end

  # 保存済みの番号から変わらない作業地は検証しない。組織の薬剤グループ数を減らした後などに
  # 上限を超える番号が残っていても、そのままでは保存できなくならないようにする。
  def validate_group_no!(work_land, group_no)
    return if group_no == work_land.chemical_group_no
    return if group_no&.between?(0, @max_group_no)

    work_land.errors.add(:base, "#{work_land.land.place}の薬剤グループ番号は0から#{@max_group_no}の整数で指定してください")
    raise ActiveRecord::RecordInvalid, work_land
  end
end
