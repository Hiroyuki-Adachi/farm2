class InitWorkTypeCacheJob < ApplicationJob
  queue_as :default

  def perform(term)
    regist_work_work_types(term)
  end

  def regist_work_work_types(term)
    Work.where(term: term).each do |w|
      w.regist_work_work_types if w.lands.exists?
    end
  end
end
