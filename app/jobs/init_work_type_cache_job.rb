class InitWorkTypeCacheJob < ApplicationJob
  queue_as :default

  def perform(term)
    Work.no_fixed(term).landable.find_each(&:regist_work_work_types)
  end
end
