require "test_helper"

class UserAdminGuardTest < ActiveSupport::TestCase
  setup do
    @admin = users(:users1)
  end

  test "最後のシステム管理者は権限を変更できない" do
    make_last_admin

    assert_not @admin.update(permission_id: :manager)
    assert_equal "admin", @admin.reload.permission_id
    assert_includes @admin.errors[:base],
                    I18n.t("activerecord.errors.models.user.attributes.base.last_admin")
  end

  test "システム管理者が複数いれば権限を変更できる" do
    assert @admin.update(permission_id: :manager)
    assert_equal "manager", @admin.reload.permission_id
  end

  test "最後のシステム管理者は削除できない" do
    make_last_admin

    assert_not @admin.destroy
    assert @admin.persisted?
    assert_includes @admin.errors[:base],
                    I18n.t("activerecord.errors.models.user.attributes.base.last_admin")
  end

  private

  def make_last_admin
    User.for_organization(@admin.organization_id).admin.where.not(id: @admin.id).find_each do |user|
      user.update!(permission_id: :manager)
    end
  end
end
