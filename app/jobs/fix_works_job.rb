class FixWorksJob < ApplicationJob
  queue_as :default

  def perform(term, fixed_at, fixed_by, works_ids)
    Fix.transaction do
      Fix.do_fix(term, Date.strptime(fixed_at, '%Y-%m-%d'), fixed_by, works_ids)
    end
  end
end
