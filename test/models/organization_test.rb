require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  test "update_term! updates organization and its users" do
    organization = organizations(:org)
    other_user = users(:user_admin_org2)
    other_user_term = other_user.term
    new_term = organization.term + 1

    organization.update_term!(new_term)

    assert_equal new_term, organization.reload.term
    organization.users.each do |user|
      assert_equal new_term, user.term
    end
    assert_equal other_user_term, other_user.reload.term
  end
end
