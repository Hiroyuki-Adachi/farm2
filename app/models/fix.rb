# == Schema Information
#
# Table name: fixes
#
#  term            :integer          default(0), not null, primary key
#  fixed_at        :date             not null, primary key
#  works_count     :integer          not null
#  hours           :integer          not null
#  works_amount    :decimal(8, )     not null
#  machines_amount :decimal(8, )     not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Fix < ActiveRecord::Base
  self.primary_keys = [:term, :fixed_at]
  before_destroy :clear_fix

  scope :usual, ->(term){where(term: term).order(fixed_at: :ASC)}

  def to_param
    return fixed_at.strftime("%Y-%m-%d")
  end

  def self.do_fix(term, fixed_at, works_ids)
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
        work.machine_results.to_a.uniq {|mr| mr.machine_id }.each do |result|
          result.update(fixed_quantity: result.quantity, fixed_adjust_id: result.adjust.id, fixed_price: result.price, fixed_amount: result.amount)
          machines_amount += result.amount
        end
        work.update(fixed_at: fixed_at)
        works_count += 1
      end

      Fix.create({term: term, fixed_at: fixed_at, works_count: works_count, hours: hours, works_amount: works_amount, machines_amount: machines_amount})
    end
  end

  private
    def clear_fix
      Work.where(term: term, fixed_at: fixed_at).each do |work|
        work.work_results.each do |result|
          result.update(fixed_hours: nil, fixed_price: nil, fixed_amount: nil)
        end
        work.machine_results.each do |result|
          result.update(fixed_quantity: nil, fixed_adjust_id: nil, fixed_price: nil, fixed_amount: nil)
        end
        work.update(fixed_at: nil)
      end
    end
end
