require "test_helper"

class ScheduleDecoratorTest < ActiveSupport::TestCase
  def decorate(model)
    ScheduleDecorator.new(model)
  end

  test "participants_count と section_participants_count を返す" do
    schedule = Schedule.new

    worker1 = Worker.new
    worker1.home = Home.new(section_id: 1)
    schedule.schedule_workers.build(worker: worker1)

    worker2 = Worker.new
    worker2.home = Home.new(section_id: 1)
    schedule.schedule_workers.build(worker: worker2)

    worker3 = Worker.new
    worker3.home = Home.new(section_id: 2)
    schedule.schedule_workers.build(worker: worker3)

    decorator = decorate(schedule)

    assert_equal 3, decorator.participants_count
    assert_equal 2, decorator.section_participants_count(1)
    assert_equal 1, decorator.section_participants_count(2)
  end
end
