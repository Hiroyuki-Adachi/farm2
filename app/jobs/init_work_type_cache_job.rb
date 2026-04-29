class InitWorkTypeCacheJob < ApplicationJob
  queue_as :default

  def perform
    Organization.find_each do |org|
      sys = System.get_system(Time.zone.today, org.id)
      next unless sys

      Work.for_organization(org).no_fixed(sys.term).landable.find_each(&:regist_work_work_types)
    end
  end
end
