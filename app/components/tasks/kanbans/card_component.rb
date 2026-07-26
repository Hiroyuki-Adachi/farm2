module Tasks
  module Kanbans
    class CardComponent < ViewComponent::Base
      def initialize(task:)
        super()
        @task = task
      end
    end
  end
end
