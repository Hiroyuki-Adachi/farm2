require 'csv'

# == Schema Information
#
# Table name: sorimachi_journals
#
#  id                   :bigint           not null, primary key
#  accounted_on(仕訳日) :date
#  amount1(金額1)       :decimal(11, 2)   default(0.0), not null
#  amount2(金額2)       :decimal(11, 2)   default(0.0), not null
#  amount3(金額3)       :decimal(11, 2)   default(0.0), not null
#  code01(コード0-1)    :string(4)        not null
#  code02(コード0-2)    :string(4)        not null
#  code03(コード0-3)    :string(4)        not null
#  code04(コード0-4)    :string(4)        not null
#  code05(コード0-5)    :string(4)        not null
#  code06(コード0-6)    :string(4)        not null
#  code07(コード0-7)    :string(4)        not null
#  code11(コード1-1)    :string(6)        not null
#  code12(コード1-2)    :string(6)        not null
#  code13(コード1-3)    :string(6)        not null
#  code14(コード1-4)    :string(6)        not null
#  code15(コード1-5)    :string(6)        not null
#  code16(コード1-6)    :string(6)        not null
#  code17(コード1-7)    :string(6)        not null
#  code18(コード1-8)    :string(6)        not null
#  code21(コード2-1)    :string(1)        not null
#  code31(コード3-1)    :string(1)        not null
#  detail(明細番号)     :integer          not null
#  line(行番号)         :integer          not null
#  remark1(備考1)       :string(50)       not null
#  remark2(備考2)       :string(50)       not null
#  remark3(備考3)       :string(50)       not null
#  remark4(備考4)       :string(50)       not null
#  term(年度(期))       :integer          not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  sorimachi_journals_2nd  (term,line,detail) UNIQUE
#
class SorimachiJournal < ApplicationRecord
  scope :usual, ->(term) {where(term: term, detail: 1).order(:line)}

  validate :term_check

  def self.import(term, file)
    SorimachiJournal.where(term: term).destroy_all
    
    CSV.foreach(file.path, encoding: "cp932", headers: false, skip_lines: /^\/\//) do |row|
      sorimachi = SorimachiJournal.new([updatable_attributes, row].transpose.to_h)
      sorimachi.term = term
      sorimachi.save!
    end
  end

  def self.details(journals)
    SorimachiJournal.where(term: journals.first.term)
      .where(line: journals.map{|j| j.line})
      .where("detail > 1")
      .order(:detail)
  end

private
  def self.updatable_attributes
    ['line', 'detail', 'accounted_on',
      'code01', 'code02', 'code03', 'code04', 'code05', 'code06', 'code07', 'amount1', 
      'code11', 'code12', 'code13', 'code14', 'code15', 'code16', 'code17', 'code18', 'amount2', 
      'code21', 'remark1', 'remark2', 'remark3', 'code31', 'amount3', 'remark4'
    ]
  end

  def term_check
    if self.accounted_on.present? && self.accounted_on.year != self.term
      errors.add(:term, "の対応に誤りがあります。")
    end
  end
end
