# == Schema Information
#
# Table name: workers(作業者マスタ)
#
#  id(作業者マスタ)                        :integer          not null, primary key
#  account_holder_name(口座氏名(半角カナ)) :string(30)       default(""), not null
#  account_number(口座番号)                :string(7)        default("0000000"), not null
#  bank_code(銀行コード)                   :string(4)        default("0000"), not null
#  birthday(誕生日)                        :date
#  branch_code(支店コード)                 :string(3)        default("000"), not null
#  broccoli_mark(ブロッコリ記号)           :string(1)
#  deleted_at                              :datetime
#  display_order(表示順)                   :integer
#  family_name(姓)                         :string(10)       not null
#  family_phonetic(姓(ﾌﾘｶﾞﾅ))         :string(15)       not null
#  first_name(名)                          :string(10)       not null
#  first_phonetic(名(ﾌﾘｶﾞﾅ))          :string(15)       not null
#  mobile(携帯番号)                        :string(15)
#  mobile_mail(メールアドレス(携帯))       :string(50)
#  office_role(事務の役割)                 :integer          default("none"), not null
#  pc_mail(メールアドレス(PC))             :string(50)
#  work_flag(作業フラグ)                   :boolean          default(TRUE), not null
#  created_at                              :datetime
#  updated_at                              :datetime
#  account_type_id(口座種別)               :integer          default("unset"), not null
#  gender_id(性別)                         :integer          default("none"), not null
#  home_id(世帯)                           :integer
#  organization_id(組織)                   :bigint           default(1), not null
#  position_id(役職)                       :integer          default("none"), not null
#
# Indexes
#
#  index_workers_on_deleted_at       (deleted_at)
#  index_workers_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
require 'test_helper'

class WorkerTest < ActiveSupport::TestCase
  setup do
    @worker = workers(:worker1)
  end

  test "有効な値" do
    assert @worker.valid?
  end

  test "口座項目は部分入力でも有効" do
    @worker.assign_attributes(
      bank_code: "",
      branch_code: "",
      account_type_id: :unset,
      account_number: "",
      account_holder_name: "ﾔﾏﾀﾞ ﾀﾛｳ"
    )

    assert @worker.valid?
  end

  test "口座氏名は入力がある場合のみ半角を検証する" do
    @worker.account_holder_name = "ヤマダ タロウ"

    assert_not @worker.valid?
    assert_not_empty @worker.errors[:account_holder_name]
  end

  test "口座コードは入力がある場合のみ書式を検証する" do
    @worker.account_number = "123"

    assert_not @worker.valid?
    assert_not_empty @worker.errors[:account_number]
  end

  test "口座情報が初期値のままなら未入力と判定される" do
    assert @worker.account_incomplete?
  end

  test "口座情報がすべて入力済みなら未入力と判定されない" do
    @worker.assign_attributes(
      bank_code: "0001",
      branch_code: "001",
      account_type_id: :regular,
      account_number: "1234567",
      account_holder_name: "ﾔﾏﾀﾞ ﾀﾛｳ"
    )

    assert_not @worker.account_incomplete?
  end

  test "名字がなければ無効" do
    @worker.family_name = nil
    assert_not @worker.valid?
  end

  test "名前がなければ無効" do
    @worker.first_name = nil
    assert_not @worker.valid?
  end

  test "名字のふりがながカタカナの場合は無効" do
    @worker.family_phonetic = "カタカナ"
    assert_not @worker.valid?
  end

  test "名前のふりがながカタカナの場合は無効" do
    @worker.first_phonetic = "カタカナ"
    assert_not @worker.valid?
  end

  test "ユーザが存在しないのに、役職が設定されている場合は無効" do
    @worker.user.destroy
    @worker.reload
    @worker.office_role = :finance
    assert_not @worker.valid?
  end

  test "ユーザ権限が一般で役職が設定された場合、ユーザ権限がサポータ権限に更新される" do
    @worker.user.update(permission_id: :user)
    @worker.reload
    @worker.office_role = :finance
    @worker.save!
    assert_equal :checker, @worker.user.permission_id.to_sym
  end

  test "ユーザ権限が管理者で役職が設定された場合、ユーザ権限は更新されない" do
    @worker.user.update(permission_id: :admin)
    @worker.reload
    @worker.office_role = :finance
    @worker.save!
    assert_equal :admin, @worker.user.permission_id.to_sym
  end

  test "別組織の世帯を指定した場合は無効" do
    @worker.home = homes(:home_other_org)

    assert_not @worker.valid?
    assert_includes @worker.errors[:home_id], "は同じ組織の世帯を指定してください。"
  end
end
