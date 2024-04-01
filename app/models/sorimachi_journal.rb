require 'csv'

# == Schema Information
#
# Table name: sorimachi_journals
#
#  id                           :bigint           not null, primary key
#  accounted_on(仕訳日)         :date
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
#  code11(コード1-1)            :bigint           not null
#  code12(コード1-2)            :bigint           not null
#  code13(コード1-3)            :bigint           not null
#  code14(コード1-4)            :bigint           not null
#  code15(コード1-5)            :bigint           not null
#  code16(コード1-6)            :bigint           not null
#  code17(コード1-7)            :bigint           not null
#  code18(コード1-8)            :bigint           not null
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
#  term(年度(期))               :integer          not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
# Indexes
#
#  sorimachi_journals_2nd  (term,line,detail) UNIQUE
#
class SorimachiJournal < ApplicationRecord
  after_update :clear_work_types
  scope :usual, ->(term) {where(term: term, detail: 1).order(:line)}
  scope :cost, ->(term) {where(term: term, cost0_flag: true).order(:line, :detail)}
  scope :total, ->(term) {where(term: term, cost0_flag: true).order(:code01).group(:code01).sum(:amount1)}

  has_many :sorimachi_work_types, dependent: :destroy
  has_many :work_types, through: :sorimachi_work_types
  has_many :details, query_constraints: [:term, :line], class_name: 'SorimachiJournal', primary_key: [:term, :line]

  validate :term_check

  belongs_to :account1, query_constraints: [:term, :code01], class_name: 'SorimachiAccount'
  belongs_to :account2, query_constraints: [:term, :code12], class_name: 'SorimachiAccount'

  def self.import(term, file)
    CSV.foreach(file.path, encoding: "cp932", headers: false, skip_lines: /^\/\//) do |row|
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
      journal.save!
    end
  end

  def self.details(journals)
    return [] unless journals.exists?
    SorimachiJournal.where(term: journals.first.term)
      .where(line: journals.map{|j| j.line})
      .where("detail > 1")
      .order(:detail)
  end

  def self.update_cost_flag(term)
    SorimachiAccount.where(term: term).each do |account|
      SorimachiJournal.where(term: term, code01: account.code).update_all(cost0_flag: account.cost_flag)
      SorimachiJournal.where(term: term, code12: account.code).update_all(cost1_flag: account.cost_flag)
    end
  end

  def self.refresh(term)
    accounts = SorimachiAccount.where(term: term).map{|a| [a.code, a.total_cost_type]}.to_h
    SorimachiJournal.where(term: term).each do |journal|
      if [TotalCostType::EXPENSEDIRECT, TotalCostType::EXPENSEINDIRECT].include?(accounts[journal.code12]) || accounts[journal.code01] == TotalCostType::SALES
        journal.swap
        journal.save!
      end
      if journal.account2&.sales? && journal.code13 == journal.account2.auto_code
        work_type_id = journal.account2.auto_work_type_id
        SorimachiWorkType.where(sorimachi_journal_id: journal.id, work_type_id: work_type_id).first_or_create
        journal.details.each do |detail|
          SorimachiWorkType.where(sorimachi_journal_id: detail.id, work_type_id: work_type_id).first_or_create if detail.cost0_flag
        end
      end
    end
  end

  def self.accounts(term)
    t1 = SorimachiJournal.where(term: term).order(:code01).group(:code01).sum(:amount1)
    t2 = SorimachiJournal.where(term: term).order(:code12).group(:code12).sum(:amount2)
    return t1.merge(t2).map {|k, _v| [k, [t1[k] || 0, t2[k] || 0]]}.to_h
  end

  def cost_amount
    self.cost0_flag ? amount1 : amount2
  end

  def update_flags
    if self.account1.present?
      self.cost0_flag = true
      self.save!
    elsif self.account2.present?
      self.cost1_flag = true
      self.save!
    end
  end

  def clear_flags
    self.update(cost0_flag: false, cost1_flag: false)
  end

  def swap
    self.amount1, self.amount2 = -self.amount2, -self.amount1
    self.code01, self.code12 = self.code12, self.code01
    self.code02, self.code13 = self.code13, self.code02
    self.code03, self.code14 = self.code14, self.code03
    self.code04, self.code15 = self.code15, self.code04
    self.code05, self.code16 = self.code16, self.code05
    self.code06, self.code17 = self.code17, self.code06
    self.code07, self.code18 = self.code18, self.code07
    self.cost0_flag, self.cost1_flag = self.cost1_flag, self.cost0_flag
    self.tax01, self.tax11 = self.tax11, self.tax01
  end

  def import_value(value)
    my_attributes = SorimachiJournal.updatable_attributes
    my_attributes.delete_if{|v| ['line', 'detail'].include?(v)}
    my_attributes.each do |key|
      self.attributes = {key => value.send(key)}
    end
  end

  def copy(sys)
    copy_src = SorimachiJournal.where("term = ? AND id < ? AND (cost0_flag = true OR cost1_flag = true)", self.term, self.id).order(id: :desc).first
    return unless copy_src
    self.work_types.destroy_all
    sum_area = 0
    max_work_type_id = 0
    max_area = 0
    land_costs = LandCost.total(self.accounted_on || sys.end_date)
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
        amount = (self.cost_amount * land_cost[1] / sum_area).round
        next if amount.zero?
        SorimachiWorkType.create(
          sorimachi_journal_id: self.id, 
          work_type_id: land_cost[0], 
          amount: amount
        )
        sum_amount += amount
      end
    end
    unless sum_amount == self.cost_amount
      sorimachi_work_type = SorimachiWorkType.where(sorimachi_journal_id: self.id, work_type_id: max_work_type_id).first
      sorimachi_work_type.increment!(:amount, self.cost_amount - sum_amount) if sorimachi_work_type
    end
    self.reload
  end

  def ==(value)
    return self.amount1 == value.amount1 &&
           self.amount2 == value.amount2 && 
           self.code01 == value.code01 &&
           self.code12 == value.code12
  end

  def self.updatable_attributes
    ['line', 'detail', 'accounted_on',
     'code01', 'code02', 'code03', 'code04', 'tax01', 'code05', 'code06', 'code07', 'amount1', 
     'code11', 'code12', 'code13', 'code14', 'code15', 'tax11', 'code16', 'code17', 'code18', 'amount2', 
     'code21', 'remark1', 'remark2', 'remark3', 'code31', 'amount3', 'remark4']
  end

  private_class_method :updatable_attributes

  private

  def term_check
    if self.accounted_on.present? && self.accounted_on.year != self.term
      errors.add(:term, "の対応に誤りがあります。")
    end
  end

  def clear_work_types
    self.sorimachi_work_types.destroy_all if !self.cost0_flag && !self.cost1_flag
  end
end
