require 'test_helper'

class MachineResultDecoratorTest < Draper::TestCase
  test "#quantity は0.5時間刻みの稼動時間を小数1位で返す" do
    machine_result = machine_results(:machine_results0)
    machine_result.stubs(:adjust).returns(Adjust::HOUR)
    machine_result.stubs(:quantity).returns(BigDecimal("2.5"))
    decorated = MachineResultDecorator.decorate(machine_result)

    assert_equal "2.5", decorated.quantity
  end

  test "#quantity は0.25時間刻みの既存稼動時間を丸めずに小数2位で返す" do
    machine_result = machine_results(:machine_results0)
    machine_result.stubs(:adjust).returns(Adjust::HOUR)
    machine_result.stubs(:quantity).returns(BigDecimal("0.25"))
    decorated = MachineResultDecorator.decorate(machine_result)

    assert_equal "0.25", decorated.quantity
  end
end
