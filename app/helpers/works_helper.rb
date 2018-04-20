module WorksHelper
  def updatable_work(user, work)
    user.checkable? || work.created_by == user.worker.id
  end
end
