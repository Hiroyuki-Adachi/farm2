require "test_helper"

class UpdateLandSortKeyJobTest < ActiveJob::TestCase
  test "init_place_sort_key が各 land に対して呼ばれる" do
    land1 = mock("land1")
    land2 = mock("land2")
    land1.expects(:init_place_sort_key).once
    land2.expects(:init_place_sort_key).once

    scope = mock("scope")
    scope.expects(:find_each).multiple_yields([land1], [land2])

    Land.expects(:target_place_sort_key).returns(scope)

    UpdateLandSortKeyJob.perform_now
  end
end
