class WorkVerificationsController < ApplicationController
  def index
    @works = WorkDecorator.decorate_collection(Work.for_verifications(@term, current_user.worker))
    respond_to do |format|
      format.html
    end
  end

  def create
    WorkVerification.regist(Work.find(params[:work_id]), current_user.worker)
    reload
  end

  def destroy
    WorkVerification.where(work_id: params[:work_id], worker_id: current_user.worker.id).destroy_all
    reload
  end

  private

  def reload
    @works = WorkDecorator.decorate_collection(Work.for_verifications(@term, current_user.worker))
    respond_to do |format|
      format.html { render partial: "list" }
    end
  end
end
