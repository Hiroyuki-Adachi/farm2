require 'test_helper'

class LandTest < ActiveSupport::TestCase
  setup do
    @land_group = lands(:land_group1)
    @land1 = lands(:lands_group1_1)
    @land2 = lands(:lands_group1_2)
  end

  test "グループ" do
    assert_equal (@land1.area + @land2.area), @land_group.area
  end
end
