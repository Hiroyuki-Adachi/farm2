class CreateTaskFromTemplateJob < ApplicationJob
  queue_as :default

  def perform
    TaskTemplate.for_auto_creation.find_each do |template|
      template.due_on_candidates_for(today: Time.zone.today).each do |due_on|
        ActiveRecord::Base.transaction do
          template.create_task(due_on: due_on)&.create_watcher_by_role
        end
      end
    end
  end
end
