# 薬剤グループを使わない作業では、作業地の薬剤グループ番号を0に戻す。
# 以前は Work の after_save で保存のたびに全作業地を更新していた(#1213)。
class Work::ChemicalGroupResetter
  def initialize(work)
    @work = work
  end

  def call
    return if @work.chemical_group_flag

    # 作業地の関連は表示順の order を持つため、関連を経由せず1回の UPDATE で戻す。
    # WorkLand に保存時のコールバックはないので update_all で足りる。
    WorkLand.where(work_id: @work.id).where.not(chemical_group_no: 0)
      .update_all(chemical_group_no: 0, updated_at: Time.current) # rubocop:disable Rails/SkipsModelValidations
  end
end
