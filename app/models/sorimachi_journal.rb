require 'csv'

# == Schema Information
#
# Table name: sorimachi_journals(ソリマチ仕訳)
#
#  id                           :bigint           not null, primary key
#  accounted_on(仕訳日)         :date
#  allocation_mode              :integer          default("auto"), not null
#  amount1(金額1)               :decimal(11, 2)   default(0.0), not null
#  amount2(金額2)               :decimal(11, 2)   default(0.0), not null
#  amount3(金額3)               :decimal(11, 2)   default(0.0), not null
#  code01(コード0-1)            :integer          not null
#  code02(コード0-2)            :integer          not null
#  code03(コード0-3)            :integer          not null
#  code04(コード0-4)            :integer          not null
#  code05(コード0-5)            :integer          not null
#  code06(コード0-6)            :integer          not null
#  code07(コード0-7)            :integer          not null
#  code11(コード1-1)            :integer          not null
#  code12(コード1-2)            :integer          not null
#  code13(コード1-3)            :integer          not null
#  code14(コード1-4)            :integer          not null
#  code15(コード1-5)            :integer          not null
#  code16(コード1-6)            :integer          not null
#  code17(コード1-7)            :integer          not null
#  code18(コード1-8)            :integer          not null
#  code21(コード2-1)            :integer          not null
#  code31(コード3-1)            :string(1)        not null
#  cost0_flag(原価フラグ(借方)) :boolean          default(FALSE), not null
#  cost1_flag(原価フラグ(貸方)) :boolean          default(FALSE), not null
#  detail(明細番号)             :integer          not null
#  line(行番号)                 :integer          not null
#  remark1(備考1)               :string(50)       not null
#  remark2(備考2)               :string(50)       not null
#  remark3(備考3)               :string(50)       not null
#  remark4(備考4)               :string(50)       not null
#  tax01(消費税0-1)             :integer
#  tax11(消費税1-1)             :integer
#  term(年度(期))               :integer          not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
# Indexes
#
#  index_sorimachi_journals_on_term_and_allocation_mode  (term,allocation_mode)
#  sorimachi_journals_2nd                                (term,line,detail) UNIQUE
#
class SorimachiJournal < ApplicationRecord
  after_update :clear_work_types
  enum :allocation_mode, { auto: 0, manual: 1, select: 2 }, prefix: :allocation_mode
  scope :usual, ->(term) { where(term: term, detail: 1).order(:line) }
  scope :cost, ->(term) { where(term: term, cost0_flag: true).order(:line, :detail) }
  scope :total, ->(term) { where(term: term, cost0_flag: true).order(:code01).group(:code01).sum(:amount1) }

  has_many :sorimachi_work_types, dependent: :destroy
  has_many :work_types, through: :sorimachi_work_types
  has_many :details, foreign_key: [:term, :line], class_name: 'SorimachiJournal', primary_key: [:term, :line]

  validate :term_check

  belongs_to :account1, foreign_key: [:term, :code01], class_name: 'SorimachiAccount'
  belongs_to :account2, foreign_key: [:term, :code12], class_name: 'SorimachiAccount'

  def self.import(term, file)
    CSV.foreach(file.path, encoding: "cp932", headers: false, skip_lines: %r{^//}) do |row|
      sorimachi_new = SorimachiJournal.new([updatable_attributes, row].transpose.to_h)
      journal = SorimachiJournal.find_by(term: term, line: row[0], detail: row[1])
      if journal.nil?
        journal = sorimachi_new
        journal.term = term
      else
        next if journal == sorimachi_new

        journal.sorimachi_work_types.destroy_all
        journal.import_value(sorimachi_new)
      end
      journal.allocation_mode = :auto
      journal.save!
    end
  end

  def self.details(journals)
    return [] unless journals.exists?

    SorimachiJournal.where(term: journals.first.term)
      .where(line: journals.map(&:line))
      .where("detail > 1")
      .order(:detail)
  end

  def self.update_cost_flag(term)
    account_codes = SorimachiAccount.where(term: term).pluck(:code)
    SorimachiJournal.where(term: term).update_all(cost0_flag: false, cost1_flag: false)
    return if account_codes.blank?

    SorimachiJournal.where(term: term, code01: account_codes).update_all(cost0_flag: true)
    SorimachiJournal.where(term: term, code12: account_codes).update_all(cost1_flag: true)
  end

  def self.refresh(term)
    accounts = SorimachiAccount.where(term: term).to_h { |a| [a.code, a.total_cost_type] }
    SorimachiJournal.where(term: term).find_each do |journal|
      if [TotalCostType::EXPENSEDIRECT, TotalCostType::EXPENSEINDIRECT].include?(accounts[journal.code12]) || accounts[journal.code01] == TotalCostType::SALES
        journal.swap
        journal.save!
      end
    end
  end

  def self.accounts(term)
    t1 = SorimachiJournal.where(term: term).order(:code01).group(:code01).sum(:amount1)
    t2 = SorimachiJournal.where(term: term).order(:code12).group(:code12).sum(:amount2)
    t1.merge(t2).to_h { |k, _v| [k, [t1[k] || 0, t2[k] || 0]] }
  end

  def cost_amount
    cost0_flag ? amount1 : amount2
  end

  def update_flags
    if account1.present?
      self.cost0_flag = true
      save!
    elsif account2.present?
      self.cost1_flag = true
      save!
    end
  end

  def clear_flags
    update(cost0_flag: false, cost1_flag: false)
  end

  def swap
    self.amount1 = -amount2
    self.amount2 = -amount1
    self.code01, self.code12 = code12, code01
    self.code02, self.code13 = code13, code02
    self.code03, self.code14 = code14, code03
    self.code04, self.code15 = code15, code04
    self.code05, self.code16 = code16, code05
    self.code06, self.code17 = code17, code06
    self.code07, self.code18 = code18, code07
    self.cost0_flag, self.cost1_flag = cost1_flag, cost0_flag
    self.tax01, self.tax11 = tax11, tax01
  end

  def import_value(value)
    my_attributes = SorimachiJournal.updatable_attributes
    my_attributes.delete_if { |v| ['line', 'detail'].include?(v) }
    my_attributes.each do |key|
      self.attributes = { key => value.send(key) }
    end
  end

  def copy(sys)
    copy_src = SorimachiJournal.where("term = ? AND id < ? AND (cost0_flag = true OR cost1_flag = true)", term, id).order(id: :desc).first
    return unless copy_src

    work_types.destroy_all
    sum_area = 0
    max_work_type_id = 0
    max_area = 0
    land_costs = LandCost.total(accounted_on || sys.end_date)
    land_costs.each do |land_cost|
      next unless copy_src.work_types.ids.include?(land_cost[0])

      sum_area += land_cost[1]
      if max_area < land_cost[1]
        max_area = land_cost[1]
        max_work_type_id = land_cost[0]
      end
    end
    sum_amount = 0
    unless sum_area.zero?
      land_costs.each do |land_cost|
        next unless copy_src.work_types.ids.include?(land_cost[0])

        amount = (cost_amount * land_cost[1] / sum_area).round
        next if amount.zero?

        SorimachiWorkType.create(
          sorimachi_journal_id: id,
          work_type_id: land_cost[0],
          amount: amount
        )
        sum_amount += amount
      end
    end
    unless sum_amount == cost_amount
      sorimachi_work_type = SorimachiWorkType.where(sorimachi_journal_id: id, work_type_id: max_work_type_id).first
      sorimachi_work_type&.increment!(:amount, cost_amount - sum_amount)
    end
    reload
  end

  def ==(other)
    amount1 == other.amount1 &&
      amount2 == other.amount2 &&
      code01 == other.code01 &&
      code12 == other.code12
  end

  def self.updatable_attributes
    ['line', 'detail', 'accounted_on',
     'code01', 'code02', 'code03', 'code04', 'tax01', 'code05', 'code06', 'code07', 'amount1',
     'code11', 'code12', 'code13', 'code14', 'code15', 'tax11', 'code16', 'code17', 'code18', 'amount2',
     'code21', 'remark1', 'remark2', 'remark3', 'code31', 'amount3', 'remark4']
  end

  private

  def term_check
    return if accounted_on.blank?

    return if System.where(term: term).where("start_date <= ? AND end_date >= ?", accounted_on, accounted_on).exists?

    errors.add(:term, "の対応に誤りがあります。")
  end

  def clear_work_types
    sorimachi_work_types.destroy_all if !cost0_flag && !cost1_flag
  end
end
