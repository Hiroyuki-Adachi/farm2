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
