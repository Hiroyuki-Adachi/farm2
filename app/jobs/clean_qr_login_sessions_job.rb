class CleanQrLoginSessionsJob < ApplicationJob
  queue_as :default

  def perform
    QrLoginSession.deletable.delete_all
  end
end
