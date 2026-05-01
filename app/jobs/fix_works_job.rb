class FixWorksJob < ApplicationJob
  queue_as :default

  def perform(organization_id, term, fixed_at, fixed_by, works_ids)
    Fix.transaction do
      Fix.do_fix(organization_id, term, Date.strptime(fixed_at, '%Y-%m-%d'), fixed_by, works_ids)
    end
  end
end
