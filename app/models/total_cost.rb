# == Schema Information
#
# Table name: total_costs # 集計原価
#
#  id                 :bigint(8)        not null, primary key
#  term               :integer          not null              # 年度(期)
#  total_cost_type_id :integer          not null              # 集計原価種別
#  occurred_on        :date             not null              # 発生日
#  work_id            :integer                                # 作業
#  expense_id         :integer                                # 経費
#  depreciation_id    :integer                                # 減価償却
#  amount             :decimal(9, )     default(0), not null  # 原価額
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class TotalCost < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :work, optional: true
  belongs_to :expense, optional: true
  belongs_to :depreciation, optional: true
  belongs_to :total_cost_type

  has_many :total_cost_details, {dependent: :destroy}

  def self.make(term)
    TotalCost.where(term: term).destroy_all
    make_work_worker(term)
  end

  def self.make_work_worker(term)
    Work.for_cost(term).each do |work|
      total_cost = TotalCost.new(
        term: term,
        total_cost_type_id: TotalCostType::WORKWORKER.id,
        occurred_on: work.worked_at,
        work_id: work.id,
        amount: work.sum_workers_amount
      )
      total_cost.save
      if (work.work_lands&.count || 0).positive?
        LandCost.sum_area_by_lands(work.worked_at, work.lands.ids).each do |k, v|
          TotalCostDetail.create(
            total_cost_id: total_cost.id,
            work_type_id: k,
            rate: 1,
            area: v
          )
        end
      else
        TotalCostDetail.create(
          total_cost_id: total_cost.id,
          work_type_id: work.work_type_id,
          rate: 1,
          area: LandCost.sum_area_by_work_type(work.worked_at, work.work_type_id)
        )
      end
    end
  end

  private_class_method :make_work_worker
end
