# == Schema Information
#
# Table name: fixes(確定データ)
#
#  fixed_at(確定日)                :date             not null, primary key
#  fixed_by(確定者)                :integer
#  hours(合計作業工数)             :integer          not null
#  machines_amount(合計機械利用料) :decimal(8, )     not null
#  term(年度(期))                  :integer          default(0), not null, primary key
#  works_amount(合計作業日当)      :decimal(8, )     not null
#  works_count(合計作業数)         :integer          not null
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  organization_id(組織)           :bigint           default(3), not null, primary key
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#

class Fix < ApplicationRecord
  class InvalidInput < StandardError; end

  self.primary_key = [:organization_id, :term, :fixed_at]
  before_destroy :clear_fix

  belongs_to :organization
  belongs_to :fixer, -> { with_deleted }, class_name: "Worker", foreign_key: "fixed_by"

  scope :for_organization, ->(organization) { where(organization_id: organization.is_a?(Organization) ? organization.id : organization) }
  scope :usual, ->(organization, term) { for_organization(organization).where(term: term).order(fixed_at: :ASC) }

  def to_param
    fixed_at.strftime("%Y-%m-%d")
  end

  def self.do_fix(organization, term, fixed_at, fixed_by, works_ids)
    organization_id = organization.is_a?(Organization) ? organization.id : organization
    fixed_at, works = validate_input!(organization_id, term, fixed_at, works_ids)
    hours = 0
    works_amount = 0
    works_count = 0
    machines_amount = 0

    works.find_each do |work|
      work.work_results.each do |result|
        price = work.work_kind.term_price(term, organization_id: organization_id)
        amount = result.hours * price
        result.update(fixed_hours: result.hours, fixed_price: price, fixed_amount: amount)
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

    Fix.create(organization_id: organization_id, term: term, fixed_at: fixed_at, works_count: works_count, hours: hours, works_amount: works_amount, machines_amount: machines_amount, fixed_by: fixed_by)
  end

  def self.validate_input!(organization, term, fixed_at, works_ids)
    organization_id = organization.is_a?(Organization) ? organization.id : organization
    date = validate_date!(organization_id, term, fixed_at)

    ids = Array(works_ids).map { |id| Integer(id.to_s, 10) }.uniq
    raise InvalidInput, "確定対象の作業を選択してください。" if ids.empty?

    works = Work.for_organization(organization_id).where(term: term, id: ids)
    raise InvalidInput, "確定対象に対象期・対象組織以外の作業、または存在しない作業が含まれています。" unless works.count == ids.size

    [date, works]
  rescue ArgumentError
    raise InvalidInput, "確定日または確定対象の作業の指定が不正です。"
  end

  def self.validate_date!(organization_id, term, fixed_at)
    system = System.find_by(organization_id: organization_id, term: term)
    date = fixed_at.is_a?(Date) ? fixed_at : Date.iso8601(fixed_at.to_s)
    unless system && date.between?(system.start_date, system.end_date)
      raise InvalidInput, "確定日は対象期の期首日から期末日までの日付を指定してください。"
    end

    date
  end
  private_class_method :validate_date!

  private

  def clear_fix
    ZenginPaymentBatch.for_organization(organization_id).find_by(term: term, fixed_at: fixed_at)&.destroy!

    Work.for_organization(organization_id).where(term: term, fixed_at: fixed_at).find_each do |work|
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
