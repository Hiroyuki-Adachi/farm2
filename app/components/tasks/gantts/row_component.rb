module Tasks
  module Gantts
    class RowComponent < ViewComponent::Base
      def initialize(task:, dates:)
        super()
        @task = task
        @dates = dates
      end

      private

      def period
        @period ||= @task.gantt_period
      end

      def in_range?(date)
        period.cover?(date)
      end

      def cell_classes(date)
        classes = ["gantt-cell"]
        classes.concat(bar_classes(date)) if in_range?(date)
        classes << "gantt-holiday" if date.saturday? || date.sunday? || HolidayJp.holiday?(date)
        classes << "gantt-today" if date == Date.current
        classes.join(" ")
      end

      def bar_classes(date)
        closed = @task.closed? ? "-closed" : ""
        classes = ["gantt-cell--bar#{closed}"]
        classes << "gantt-cell--start#{closed}" if date == period.begin
        classes << "gantt-cell--end#{closed}"   if date == period.end
        classes
      end
    end
  end
end
