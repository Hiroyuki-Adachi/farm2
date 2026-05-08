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
require 'test_helper'

class SorimachiJournalTest < ActiveSupport::TestCase
  setup do
    @term = 2090
    organization = Organization.create!(name: "仕訳テスト", term: @term)
    System.create!(
      organization_id: organization.id,
      term: @term,
      start_date: Date.new(2090, 4, 1),
      end_date: Date.new(2091, 3, 31)
    )
    SorimachiAccount.create!(term: @term, code: 9001, name: "借方")
    SorimachiAccount.create!(term: @term, code: 9002, name: "貸方")
  end

  test "仕訳日は暦年ではなく期首期末で判定する" do
    journal = build_journal(accounted_on: Date.new(2091, 2, 1))

    assert_predicate journal, :valid?
  end

  test "仕訳日が期外なら不正" do
    journal = build_journal(accounted_on: Date.new(2091, 4, 1))

    assert_not_predicate journal, :valid?
    assert_includes journal.errors[:term], "の対応に誤りがあります。"
  end

  private

  def build_journal(accounted_on:)
    SorimachiJournal.new(
      term: @term,
      line: 999,
      detail: 1,
      accounted_on: accounted_on,
      code01: 9001,
      code02: 0,
      code03: 0,
      code04: 0,
      code05: 0,
      code06: 0,
      code07: 0,
      amount1: 100,
      code11: 0,
      code12: 9002,
      code13: 0,
      code14: 0,
      code15: 0,
      code16: 0,
      code17: 0,
      code18: 0,
      amount2: 100,
      code21: 0,
      code31: "0",
      remark1: "",
      remark2: "",
      remark3: "",
      remark4: "",
      cost0_flag: false,
      cost1_flag: false
    )
  end
end
