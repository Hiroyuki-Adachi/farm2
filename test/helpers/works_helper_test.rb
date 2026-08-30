require "test_helper"

class WorksHelperTest < ActionView::TestCase
  include WorksHelper

  test "#machine_hours_step は値が無ければ0.5を返す" do
    assert_equal 0.5, machine_hours_step(nil)
  end

  test "#machine_hours_step は0.5刻みの値なら0.5を返す" do
    assert_equal 0.5, machine_hours_step(BigDecimal("2.5"))
  end

  test "#machine_hours_step は0.5刻みでない既存データなら0.25を返す" do
    assert_equal 0.25, machine_hours_step(BigDecimal("1.25"))
  end
end
