# 薬剤グループを使わない作業では、作業地の薬剤グループ番号を0に戻す。
# 以前は Work の after_save で保存のたびに全作業地を更新していた(#1213)。
class Work::ChemicalGroupResetter
  def initialize(work)
    @work = work
  end

  def call
    return if @work.chemical_group_flag

    @work.work_lands.where.not(chemical_group_no: 0).find_each do |work_land|
      work_land.update!(chemical_group_no: 0)
    end
  end
end
