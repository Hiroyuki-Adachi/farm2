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
