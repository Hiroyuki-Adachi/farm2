# 年度の集計原価を作り直す。
# 既存の集計原価を削除し、確定日までの作業から原価を再生成して、作業分類ごとの明細へ配賦する。
class TotalCost::Rebuilder
  def initialize(organization, term, fixed_on)
    @organization_id = organization.is_a?(Organization) ? organization.id : organization
    @term = term
    @fixed_on = fixed_on
  end

  def call
    TotalCost.for_organization(@organization_id).where(term: @term).destroy_all
    make_work
    make_details
  end

  def make_details
    TotalCost.for_organization(@organization_id).where(term: @term).find_each do |tc|
      tc.total_cost_details.each do |tcd|
        next if tcd.rate.zero?

        tcd.cost = tc.cost(tcd.work_type_id)
        tcd.base_cost = tc.base_cost(tcd.work_type_id)
        tcd.save!
      end
    end
  end

  def make_work_worker(work)
    total_cost = TotalCost.create(
      term: @term,
      total_cost_type_id: work.total_cost_type.id,
      occurred_on: work.worked_at,
      work_id: work.id,
      organization_id: work.organization_id,
      amount: work.sum_workers_amount,
      display_order: work.work_kind_order,
      cost_type_id: work.work_kind.cost_type_id,
      member_flag: true
    )
    if work.work_type.cost_flag || work.work_lands.exists?
      make_work_details(work, total_cost)
    else
      make_details_for_indirect(total_cost, work.worked_at)
    end
  end

  def make_details_for_indirect(total_cost, occurred_on)
    WorkType.land.by_term(@term).kept.each do |work_type|
      next unless work_type.cost_flag

      area = LandCost.sum_area_by_work_type(occurred_on, work_type.id, total_cost.organization_id)
      next unless area.positive?

      TotalCostDetail.create(
        total_cost_id: total_cost.id,
        work_type_id: work_type.id,
        rate: 1,
        area: area
      )
    end
  end

  private

  def make_work
    Work.for_organization(@organization_id).by_term(@term).where(worked_at: ..@fixed_on).find_each do |work|
      make_work_worker(work)
    end
  end

  def make_work_details(work, total_cost)
    if work.work_type.cost_only?
      TotalCostDetail.create(
        total_cost_id: total_cost.id,
        work_type_id: work.work_type_id,
        area: 0
      )
    elsif (work.work_lands&.count || 0).positive?
      LandCost.sum_area_by_lands(work.worked_at, work.lands.ids, work.organization_id).each do |k, v|
        TotalCostDetail.create(
          total_cost_id: total_cost.id,
          work_type_id: k,
          area: v
        )
      end
    else
      TotalCostDetail.create(
        total_cost_id: total_cost.id,
        work_type_id: work.work_type_id,
        area: LandCost.sum_area_by_work_type(work.worked_at, work.work_type_id, work.organization_id)
      )
    end
  end
end
