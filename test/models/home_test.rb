require 'test_helper'

class HomeTest < ActiveSupport::TestCase
  test "別組織の班を指定した場合は無効" do
    home = homes(:home1)
    home.section = sections(:section_other_org)

    assert_not home.valid?
    assert_includes home.errors[:section_id], "は同じ組織の班を指定してください。"
  end
end
