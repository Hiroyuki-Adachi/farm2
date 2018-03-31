class WorkVerificationsController < ApplicationController
  before_action :set_work, only: [:show_workers, :show_lands]

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

  def show_workers
    @results = WorkResultDecorator.decorate_collection(@work.work_results || [])
    respond_to do |format|
      format.html { render partial: "show_workers" }
    end
  end

  def show_lands
    @work_lands = WorkLandDecorator.decorate_collection(@work.work_lands || [])
    respond_to do |format|
      format.html { render partial: "show_lands" }
    end
  end

  private

  def reload
    @works = WorkDecorator.decorate_collection(Work.for_verifications(@term, current_user.worker))
    respond_to do |format|
      format.html { render partial: "list" }
    end
  end

  def set_work
    @work = Work.find(params[:work_id]).decorate
  end
end
