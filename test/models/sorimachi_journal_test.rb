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
    @system = System.create!(
      organization_id: organization.id,
      term: @term,
      term_name: @term.to_s,
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

  test "別組織の期間内でも対象組織の期間外なら不正" do
    System.create!(organization_id: Organization.create!(name: "別組織の仕訳").id, term: @term, term_name: "別組織の期",
                   start_date: Date.new(2091, 4, 1), end_date: Date.new(2091, 6, 30))
    journal = build_journal(accounted_on: Date.new(2091, 4, 1))

    assert_not_predicate journal, :valid?
    assert_includes journal.errors[:term], "の対応に誤りがあります。"
  end

  test "短い期の期首期末は有効でその前後は不正" do
    @system.update!(end_date: Date.new(2090, 6, 30))

    [@system.start_date, @system.end_date].each do |date|
      assert_predicate build_journal(accounted_on: date), :valid?
    end
    [@system.start_date - 1, @system.end_date + 1].each do |date|
      assert_not_predicate build_journal(accounted_on: date), :valid?
    end
  end

  test "対象期が未指定または期番号が異なると不正" do
    journal = build_journal(accounted_on: @system.start_date)
    journal.validation_system = nil
    assert_not_predicate journal, :valid?

    journal.validation_system = systems(:s2015)
    assert_not_predicate journal, :valid?
  end

  test "日付のない決算仕訳は従来どおり有効" do
    journal = build_journal(accounted_on: nil)
    journal.validation_system = nil

    assert_predicate journal, :valid?
  end

  test "再読込後の配賦変更は可能だが日付変更には対象期が必要" do
    journal = build_journal(accounted_on: @system.start_date)
    journal.save!
    journal = SorimachiJournal.find(journal.id)
    journal.update!(allocation_mode: :manual)
    journal.accounted_on += 1

    assert_not_predicate journal, :valid?
    journal.validation_system = @system
    assert_predicate journal, :valid?
  end

  test "再読込後の期番号変更には対象期が必要" do
    journal = build_journal(accounted_on: @system.start_date)
    journal.save!
    journal = SorimachiJournal.find(journal.id)
    journal.term = 2015
    journal.valid?

    assert_includes journal.errors[:term], "の対応に誤りがあります。"
  end

  test "再取込は金額が同じでも仕訳日変更を検証する" do
    journal = build_journal(accounted_on: @system.start_date)
    journal.save!
    journal.accounted_on = @system.end_date + 1

    with_import_file(journal) do |file|
      assert_raises(ActiveRecord::RecordInvalid) { SorimachiJournal.import(@system, file) }
    end
    assert_equal @system.start_date, journal.reload.accounted_on
  end

  test "変更のない再取込でも対象組織の期間を検証する" do
    journal = build_journal(accounted_on: @system.start_date)
    journal.save!
    other_organization = Organization.create!(name: "別組織の仕訳")
    other_system = System.create!(organization_id: other_organization.id, term: @term, term_name: "別組織の期",
                                  start_date: Date.new(2091, 4, 1), end_date: Date.new(2091, 6, 30))

    with_import_file(journal) do |file|
      assert_raises(ActiveRecord::RecordInvalid) { SorimachiJournal.import(other_system, file) }
    end
  end

  test "再取込で期内の日付だけを変更できる" do
    journal = build_journal(accounted_on: @system.start_date)
    journal.save!
    journal.accounted_on = @system.end_date

    with_import_file(journal) { |file| SorimachiJournal.import(@system, file) }

    assert_equal @system.end_date, journal.reload.accounted_on
  end

  private

  def with_import_file(journal)
    Tempfile.create(["sorimachi", ".csv"], binmode: true) do |file|
      row = SorimachiJournal.updatable_attributes.map { |key| journal.public_send(key) }
      file.write(CSV.generate_line(row).encode("Windows-31J"))
      file.flush
      yield file
    end
  end

  def build_journal(accounted_on:)
    sorimachi_journals(:journal1).dup.tap do |journal|
      journal.assign_attributes(validation_system: @system, term: @term, line: 999,
                                accounted_on: accounted_on, code01: 9001, code12: 9002,
                                cost0_flag: false, cost1_flag: false)
    end
  end
end
