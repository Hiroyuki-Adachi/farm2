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
require 'test_helper'

class SorimachiJournalTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
