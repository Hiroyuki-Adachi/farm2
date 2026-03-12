# == Schema Information
#
# Table name: workers(作業者マスタ)
#
#  id(作業者マスタ)                  :integer          not null, primary key
#  birthday(誕生日)                  :date
#  broccoli_mark(ブロッコリ記号)     :string(1)
#  deleted_at                        :datetime
#  display_order(表示順)             :integer
#  family_name(姓)                   :string(10)       not null
#  family_phonetic(姓(ﾌﾘｶﾞﾅ))   :string(15)       not null
#  first_name(名)                    :string(10)       not null
#  first_phonetic(名(ﾌﾘｶﾞﾅ))    :string(15)       not null
#  mobile(携帯番号)                  :string(15)
#  mobile_mail(メールアドレス(携帯)) :string(50)
#  office_role(事務の役割)           :integer          default("none"), not null
#  pc_mail(メールアドレス(PC))       :string(50)
#  work_flag(作業フラグ)             :boolean          default(TRUE), not null
#  created_at                        :datetime
#  updated_at                        :datetime
#  gender_id(性別)                   :integer          default("none"), not null
#  home_id(世帯)                     :integer
#  position_id(役職)                 :integer          default("none"), not null
#
# Indexes
#
#  index_workers_on_deleted_at  (deleted_at)
#
require 'test_helper'

class WorkerTest < ActiveSupport::TestCase
  setup do
    @worker = workers(:worker1)
  end
    
  test "有効な値" do
    assert @worker.valid?
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
end
