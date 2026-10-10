require 'test_helper'

class Statistics::MachineDecoratorTest < Draper::TestCase
  # This test only uses build_stubbed and the supplied aggregation context.
  # fixtures() merges inherited names, so reset both loading and accessors explicitly.
  self.fixture_table_names = []
  self.fixture_sets = {}

  test "#hours は稼働時間があれば小数点1位で返す" do
    machine = FactoryBot.build_stubbed(:machine, owner: nil)
    decorated = Statistics::MachineDecorator.decorate(machine, context: { hours: { [2020, machine.id] => 4 } })

    assert_equal "4.0", decorated.hours(2020)
  end

  test "#hours は集計が無ければ空文字を返す" do
    machine = FactoryBot.build_stubbed(:machine, owner: nil)
    decorated = Statistics::MachineDecorator.decorate(machine, context: { hours: {} })

    assert_equal "", decorated.hours(2020)
  end

  test "#hours は集計が0なら空文字を返す" do
    machine = FactoryBot.build_stubbed(:machine, owner: nil)
    decorated = Statistics::MachineDecorator.decorate(machine, context: { hours: { [2020, machine.id] => 0 } })

    assert_equal "", decorated.hours(2020)
  end
end
