# == Schema Information
#
# Table name: fixes # 確定データ
#
#  term            :integer          default(0), not null, primary key # 年度(期)
#  fixed_at        :date             not null, primary key             # 確定日
#  works_count     :integer          not null                          # 合計作業数
#  hours           :integer          not null                          # 合計作業工数
#  works_amount    :decimal(8, )     not null                          # 合計作業日当
#  machines_amount :decimal(8, )     not null                          # 合計機械利用料
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  fixed_by        :integer                                            # 確定者
#

class Fix < ApplicationRecord
  self.primary_keys = [:term, :fixed_at]
  before_destroy :clear_fix

  belongs_to :fixer, -> {with_deleted}, {class_name: "Worker", foreign_key: "fixed_by"}

  scope :usual, ->(term) {where(term: term).order(fixed_at: :ASC)}

  def to_param
    return fixed_at.strftime("%Y-%m-%d")
  end

  def self.do_fix(term, fixed_at, fixed_by, works_ids)
    hours = 0
    works_amount = 0
    works_count = 0
    machines_amount = 0
    Fix.transaction do
      Work.find(works_ids).each do |work|
        work.work_results.each do |result|
          amount = result.hours * work.work_kind.price
          result.update(fixed_hours: result.hours, fixed_price: work.work_kind.price, fixed_amount: amount)
          works_amount += amount
          hours += result.hours
        end
        work.machine_results.to_a.uniq(&:machine_id).each do |result|
          result.update(fixed_quantity: result.quantity, fixed_adjust_id: result.adjust.id, fixed_price: result.price, fixed_amount: result.amount)
          machines_amount += result.amount
        end
        work.work_lands.each do |work_land|
          work_land.update(fixed_cost: work_land.cost)
        end
        work.update(fixed_at: fixed_at)
        works_count += 1
      end

      Fix.create(term: term, fixed_at: fixed_at, works_count: works_count, hours: hours, works_amount: works_amount, machines_amount: machines_amount, fixed_by: fixed_by)
    end
  end

  private

  def clear_fix
    Work.where(term: term, fixed_at: fixed_at).find_each do |work|
      work.work_results.each do |result|
        result.update(fixed_hours: nil, fixed_price: nil, fixed_amount: nil)
      end
      work.machine_results.each do |result|
        result.update(fixed_quantity: nil, fixed_adjust_id: nil, fixed_price: nil, fixed_amount: nil)
      end
      work.work_lands.each do |work_land|
        work_land.update(fixed_cost: nil)
      end
      work.update(fixed_at: nil)
    end
  end
end
